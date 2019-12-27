import 'package:flutter/material.dart';

import 'dice_configuration.dart';
import 'dice_play.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generic dice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Generic dice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dicesConfiguration = UserDicesConfiguration();
  var diceNameController = TextEditingController();

  @override
  void dispose() {
    diceNameController.dispose();
    super.dispose();
  }

  void _createDice(String diceName) {
    setState(() {
      var configuration = SingleDiceConfiguration();
      configuration.values = ["1", "2", "3", "4", "5", "6"];
      dicesConfiguration.dices[diceName] = configuration;
    });
    Navigator.pop(context);
  }

  void _selectDice(String diceName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DicePlayPage()));
  }

  void _addDice() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose dice name"),
            content: TextField(
              controller: diceNameController,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _createDice(diceNameController.text);
                },
                child: Text("Ok"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dicesComponents =
        dicesConfiguration.dices.entries.map((config) {
          return Row(children: <Widget>[
            Expanded(flex: 8, child: FlatButton(child: Text(config.key), onPressed: () {_selectDice(config.key);}),),
            Expanded(flex: 1, child: FlatButton(child: Text("Ed"),),),
            Expanded(flex: 1, child: FlatButton(child: Text("Del"),),)
          ]);}).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: dicesComponents,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addDice,
      ),
    );
  }
}
