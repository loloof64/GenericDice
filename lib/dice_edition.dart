import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'generated/locale_base.dart';
import 'utils.dart';

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
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    if (_valuesControllers.length == 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(loc.editDice.emptyDiceTitle),
              content: Text(loc.editDice.emptyDiceMessage),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(loc.main.ok),
                  color: Colors.blue,
                ),
              ],
            );
          });
      return;
    }
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
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    setState(() {
      final controller = TextEditingController(text: loc.editDice.sampleValue);
      _valuesControllers.add(controller);
      _values.add("");
    });
  }

  void _resetValues() {
    setState(() {
      _values = List<String>.from(_originals);
      _valuesControllers = _originals.map((singleValue) {
        return TextEditingController(text: singleValue);
      }).toList();
    });
  }

  void _cancel() {
    Navigator.pop(context, _originals);
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
              child: Transform.scale(
                scale: 1.2,
                child: Tab(
                  icon: Image.asset('assets/images/delete.png'),
                ),
              ),
              onPressed: () => _deleteItem(item.key),
            ),
            flex: 1,
          ),
        ],
      );
    }).toList();

    final loc = Localizations.of<LocaleBase>(context, LocaleBase);

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(replaceVariables(
              loc.editDice.pageTitle, {"diceName": _diceName})),
          leading: Container(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text(loc.editDice.updateButton),
                      color: Colors.orange,
                      onPressed: _returnNewValuesToCaller,
                    ),
                    FlatButton(
                      child: Text(loc.editDice.resetButton),
                      color: Colors.purple,
                      onPressed: _resetValues,
                    ),
                    FlatButton(
                      child: Text(loc.editDice.cancelButton),
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
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
