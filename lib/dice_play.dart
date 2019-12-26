import 'package:flutter/material.dart';

import 'dice.dart';

class DicePlayPage extends StatefulWidget {
  DicePlayPage({Key key}) : super(key: key);

  @override
  _DicePlayPageState createState() => _DicePlayPageState();
}

class _DicePlayPageState extends State<DicePlayPage> {
  Dice _dice = Dice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Playing dice"),
      ),
      body: Center(
        child: _dice,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dice.launch();
        },
        tooltip: 'Launch dice',
        child: Icon(Icons.add),
      ),
    );
  }
}
