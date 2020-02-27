// To parse this JSON data, do
//
//     final furniture = furnitureFromJson(jsonString);

// import 'dart:convert';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

// Furniture furnitureFromJson(String str) => Furniture.fromJson(json.decode(str));

// String furnitureToJson(Furniture data) => json.encode(data.toJson());

class FurnitureController {
  Furniture _furniture;

  Future<Furniture> getFurniture() async {
    _furniture = null;
    Dio _dio = Dio();
    try {
      Response _res = await _dio.get("http://www.mocky.io/v2/5c9105cb330000112b649af8");   
      if (_res.statusCode == 200) {
        _furniture = Furniture.fromJson(_res.data);
      }
    } catch (err) {
      print(err);
    }
    return _furniture;
  } 

  List<Product> searchProduct(String keyword, List<String> style, List<int> deliveryTime) {
    List<Product> _products = [];
    // print("masuk sini " + _furniture.products.length.toString());
    if (_furniture != null) {
      _products = _furniture.products.where((el) {
        bool _isKeywordMatched = el.name.toLowerCase().contains(keyword.toLowerCase());

        // print(el.name);
        // print(el.furnitureStyle.toString());
        // print(el.deliveryTime);
        // print("=========================\n\n\n");

        // print("keyword $keyword: $_isKeywordMatched");
        bool _isStyleMatched =  false;

        for(int i=0; i < style.length; i++) {
          if (el.furnitureStyle.contains(style[i])) {
            _isStyleMatched = true;
            break;
          } 

        }
        // print("style $style $_isStyleMatched");

            // 1 - 1 day
            // 2 - 2 days
            // 3 - 3 days 
            // 4 - 6 days
            // 7 = 13 days
            // 14 -30 days
            // 31 - 0 days

        bool _isDeliveryMatched = false; 
        if (deliveryTime[0] > 0) {
          if (deliveryTime[0] == deliveryTime[1]) {
            _isDeliveryMatched = (deliveryTime[0] ==  int.parse(el.deliveryTime));
          } else if (deliveryTime[1] > deliveryTime[0]) {
            _isDeliveryMatched = (deliveryTime[0] <= int.parse(el.deliveryTime) && deliveryTime[1] >= int.parse(el.deliveryTime));
          } 
        } 
        // print("deliver  $deliveryTime $_isDeliveryMatched");

        return (_isKeywordMatched && _isStyleMatched && _isDeliveryMatched);

      }).toList();
    }

    // for(int i = 0; i < _products.length; i++) {
    //   print("produknya adalah: " + _products[i].name);

    // }
    return _products;
  }


}

class Furniture {
    List<String> furnitureStyles;
    List<Product> products;

    Furniture({
        this.furnitureStyles,
        this.products,
    });

    factory Furniture.fromJson(Map<String, dynamic> json) => Furniture(
        furnitureStyles: json["furniture_styles"] == null ? null : List<String>.from(json["furniture_styles"].map((x) => x)),
        products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "furniture_styles": furnitureStyles == null ? null : List<dynamic>.from(furnitureStyles.map((x) => x)),
        "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    String name;
    String description;
    List<String> furnitureStyle;
    String deliveryTime;
    int price;

    Product({
        this.name,
        this.description,
        this.furnitureStyle,
        this.deliveryTime,
        this.price,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        furnitureStyle: json["furniture_style"] == null ? null : List<String>.from(json["furniture_style"].map((x) => x)),
        deliveryTime: json["delivery_time"] == null ? null : json["delivery_time"],
        price: json["price"] == null ? null : json["price"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "furniture_style": furnitureStyle == null ? null : List<dynamic>.from(furnitureStyle.map((x) => x)),
        "delivery_time": deliveryTime == null ? null : deliveryTime,
        "price": price == null ? null : price,
    };
}
