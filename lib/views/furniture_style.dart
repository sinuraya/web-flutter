import 'package:flutter/material.dart';

class FurnitureStyle extends StatefulWidget {
  FurnitureStyle({Key key, this.values, this.onChange}) : super(key: key);

  final ValueChanged<List<bool>> onChange;
  final List<bool> values;

  @override
  _FurnitureStyleState createState() => _FurnitureStyleState();
}

class _FurnitureStyleState extends State<FurnitureStyle> {
  bool _contemporary =  false;
  bool _modern = false;
  bool _scandinavian = false;
  bool _classic = false;
  bool _midcentury = false;



  void _onChange() {
    widget.values[0] = _contemporary;
    widget.values[1] = _modern;
    widget.values[2] = _scandinavian;
    widget.values[3] = _classic;
    widget.values[4] = _midcentury;
    widget.onChange(widget.values);
  }

  @override
  void initState() {
    super.initState();
    _contemporary = widget.values[0];
    _modern = widget.values[1];
    _scandinavian = widget.values[2];
    _classic = widget.values[3];
    _midcentury = widget.values[4];

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Container(
        width: 300.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Contemporary"),
                Checkbox(
                  value: _contemporary, 
                  onChanged: (val) {
                    setState(() {
                      _contemporary = val;
                      _onChange();
                    });
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Modern"),
                Checkbox(
                  value: _modern, 
                  onChanged: (val) {
                    setState(() {
                      _modern = val;
                      _onChange();
                    });
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Scandinavian"),
                Checkbox(
                  value: _scandinavian, 
                  onChanged: (val) {
                    setState(() {
                      _scandinavian = val;
                      _onChange();
                    });
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Classic"),
                Checkbox(
                  value: _classic, 
                  onChanged: (val) {
                    setState(() {
                      _classic = val;
                      _onChange();
                    });
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Midcentury"),
                Checkbox(
                  value: _midcentury, 
                  onChanged: (val) {
                    setState(() {
                      _midcentury = val;
                      _onChange();
                    });
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}