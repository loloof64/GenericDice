import 'package:flutter/material.dart';

import 'dice.dart';

class DicePlayPage extends StatefulWidget {
  final String diceName;
  final List<String> values;

  DicePlayPage(this.diceName, this.values);

  @override
  _DicePlayPageState createState() => _DicePlayPageState(diceName, values);
}

class _DicePlayPageState extends State<DicePlayPage> {
  Dice _dice;
  final String diceName;
  final List<String> values;

  _DicePlayPageState(this.diceName, this.values) {
    this._dice = new Dice(values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playing dice " + diceName),
      ),
      body: Center(
        child: _dice,
      ),
    );
  }
}
