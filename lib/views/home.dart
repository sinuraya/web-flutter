import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mebel/models/furniture_model.dart';
import 'package:mebel/views/furniture_style.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String _searchString;
  List<bool> _furnitureStyle = [false, false, false, false, false];
  List<String> _styleEnum = [
    "Contemporary",
    "Modern",
    "Scandinavian",
    "Classic",
    "Midcentury"
  ];

  final numFormat = new NumberFormat("#,###", "id_ID");

  List<String> _styles = [];
  List<int> _deliverDays = [];

  List<Map<String,List<int>>> _deliveryTime = [
    {"1 day" : [1,1]},
    {"2 days" : [2,2]},
    {"3 days" : [3,3]},
    {"1 week" : [4,6]},
    {"2 weeks" : [7,13]},
    {"1 month" : [14,30]},
    {"1 month +" : [31,0]},

  ];
  String _optionSelect = "Delivery Time";
  List<Product> _products = [];

  void getStyles() {
    _styles.clear();
    for(int i = 0; i < _furnitureStyle.length; i++) {
      if (_furnitureStyle[i]) {
        _styles.add(_styleEnum[i]);
      }
    }    
  }

  RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox bar = c.findRenderObject();
    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.bottomLeft(Offset.zero), ancestor: overlay),
        bar.localToGlobal(bar.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }

  void _showStyle(BuildContext context, GlobalKey objKey) {
    final _pos = buttonMenuPosition(objKey.currentContext);
    showMenu(
      context: context, 
      position: _pos, 
      items: <PopupMenuItem<Widget>>[
        PopupMenuItem<Widget>(
          child: FurnitureStyle(
            values: _furnitureStyle,
            onChange: (value) {
              setState(() {
                _furnitureStyle = value;
                getStyles();
                print(value);
              });
            },
          )
        ) 
      ]
    );
  }

  void searchFurniture() {
    FurnitureController fc = FurnitureController();
    fc.getFurniture().then((value) {
      setState(() {
        _products = fc.searchProduct(_searchString, _styles, _deliverDays);
      });          
    });
  }

  void _showDelivery(BuildContext context, GlobalKey objKey) {
    final _pos = buttonMenuPosition(objKey.currentContext);
    // 1 day
    // 2 days
    // 3 days 
    // 4 - 6 days
    // 7 = 13 days
    // 14 -30 days
    // 31 days 
    List<PopupMenuItem<Map<String,List<int>>>> _popup = _deliveryTime.map((e) {
      String _label = e.keys.toList()[0];
      return PopupMenuItem<Map<String,List<int>>>(
        child: Text(_label),
        value: e,
      );
    }).toList();
    showMenu(
      context: context, 
      position: _pos, 
      items: _popup,
    ).then((value) {
      setState(() {
        _optionSelect = value.keys.toList()[0];
        _deliverDays = value.values.toList()[0];
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final styleKey = GlobalKey();
    final deliveryKey = GlobalKey();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 230.0,
                      height: 60.0,
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 18.0),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0
                            )
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0
                            )
                          ),
                          isDense: true,
                          hintText: "Search Furniture",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          )
                        ),
                        onSubmitted: (value) {
                          _searchString = value;
                          print("submitted:  $_searchString");
                          searchFurniture();
                          print(_products);
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      height:40,
                      child: FlatButton(
                        onPressed: () {
                          // _searchString = value;
                          print("ok $_searchString");
                          searchFurniture();
                          print(_products);
                        }, 
                        child: Text(
                          "Cari", 
                          style: TextStyle(
                            fontSize: 18.0

                        ),),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    runSpacing: 10.0,
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showStyle(context, styleKey);
                          print("Select Furniture Style");
                        },
                        child: Container(
                          key: styleKey,
                          width:  250.0,
                          color: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          child: Text(_styles.length == 0 ? "Furniture Style" : _styles.toString(), 
                            style: TextStyle(
                              color: Colors.black38
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDelivery(context, deliveryKey);
                          print("Select Delivery time");
                        },
                        child: Container(
                          width:  250.0,
                          color: Colors.white,
                          key: deliveryKey,
                          padding: EdgeInsets.all(6.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_optionSelect, 
                                style: TextStyle(
                                  color: Colors.black
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          (_products.length > 0) ?  
          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      ..._products.map((e) {
                        return Card(
                          margin: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Container(
                            width: 350.0,
                            height: 180.0,
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(e.name.trim(), style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      ),
                                    ),
                                    Text(numFormat.format( e.price), style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 120,
                                  child: Text(e.description,
                                    overflow: TextOverflow.fade, 
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        
                                      },
                                      child: Text(e.furnitureStyle.join(", "),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                    Text("Delivery Days: ${e.deliveryTime} days", 
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList()                      
                    ],
                  )
                ],
              ),              
            ),
          ) : Container()
        ],
      ),
    );
  }
}