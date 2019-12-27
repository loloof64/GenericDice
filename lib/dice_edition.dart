import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
    _valuesControllers = _originals.map((singleValue) {
      return TextEditingController(text: singleValue);
    }).toList();
  }

  void _returnNewValuesToCaller() {
    final updatedValues = _valuesControllers.map((singleCtrl) {
      return singleCtrl.text;
    }).toList();
    Navigator.pop(context, updatedValues);
  }

  void _deleteItem(itemIndex) {
    setState(() {
      _values.removeAt(itemIndex);
      _valuesControllers.removeAt(itemIndex);
    });
  }

  void _addItem() {
    setState(() {
      final controller = TextEditingController(text: "Sample");
      _valuesControllers.add(controller);
      _values.add("");
    });
  }

  void _resetValues() {
    setState(() {
      _values = _originals;
      _valuesControllers = _originals.map((singleValue) {
        return TextEditingController(text: singleValue);
      }).toList();
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final generatedChildren = _values.asMap().entries.map((item) {
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: TextField(
                controller: _valuesControllers[item.key],
              ),
              margin: EdgeInsets.all(10.0),
            ),
            flex: 8,
          ),
          Expanded(
            child: FlatButton(
              child: Text("Del"),
              onPressed: () => _deleteItem(item.key),
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
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text("Update"),
                    color: Colors.orange,
                    onPressed: _returnNewValuesToCaller,
                  ),
                  FlatButton(
                    child: Text("Reset"),
                    color: Colors.purple,
                    onPressed: _resetValues,
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    color: Colors.red,
                    onPressed: _cancel,
                  )
                ],
              ),
              margin: EdgeInsets.all(10.0),
            ),
            flex: 1,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: generatedChildren,
              ),
            ),
            flex: 9,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addItem,
      ),
    );
  }
}
