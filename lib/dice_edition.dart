import 'package:flutter/material.dart';

class DiceEditionPage extends StatefulWidget {
  final List<String> oldValues;
  final String diceName;

  DiceEditionPage(this.diceName, this.oldValues);

  @override
  _DiceEditionPageState createState() =>
      _DiceEditionPageState(oldValues, diceName);
}

class _DiceEditionPageState extends State<DiceEditionPage> {
  List<String> _values;
  List<String> _originals;
  List<TextEditingController> _valuesControllers;
  String _diceName;

  _DiceEditionPageState(List<String> oldValues, String diceName) {
    _diceName = diceName;
    _originals = List<String>.from(oldValues);
    _values = oldValues;
    _valuesControllers = oldValues.map((singleValue) {
      return TextEditingController(text: singleValue);
    }).toList();
  }

  void _returnNewValuesToCaller() {
    final updatedValues = _valuesControllers.map((singleCtrl) {
      return singleCtrl.text;
    }).toList();
    Navigator.pop(context, updatedValues);
  }

  @override
  Widget build(BuildContext context) {
    final generatedChildren = _values.asMap().entries.map((item) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(child: TextField(
              controller: _valuesControllers[item.key],
            ), margin: EdgeInsets.all(10.0),),
            flex: 9,
          ),
          Expanded(
            child: FlatButton(
              child: Text("Clr"),
              onPressed: () {
                _valuesControllers[item.key].text = _originals[item.key];
              },
            ),
            flex: 1,
          ),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Editing dice " + _diceName)),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text("Update"),
            color: Colors.orange,
            onPressed: _returnNewValuesToCaller,
          ),
          ListView(
            children: generatedChildren,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          )
        ],
      ),
    );
  }
}