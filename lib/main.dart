import 'package:flutter/material.dart';
import 'package:generic_dice/dice_edition.dart';

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

  void _showErrorDialog(diceName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Dice already present"),
            content: Text("You already have dice " + diceName + "."),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Ok"),
                color: Colors.blue,
              ),
            ],
          );
        });
  }

  void _createDice(String diceName) {
    var configuration = SingleDiceConfiguration();
    if (dicesConfiguration.dices.containsKey(diceName)) {
      _showErrorDialog(diceName);
      return;
    }
    setState(() {
      configuration.values = ["1", "2", "3", "4", "5", "6"];
      dicesConfiguration.dices[diceName] = configuration;
    });
    Navigator.pop(context);
  }

  void _selectDice(String diceName) {
    final values = dicesConfiguration.dices[diceName].values;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DicePlayPage(diceName, values)));
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
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                color: Colors.red,
              )
            ],
          );
        });
  }

  void _deleteDice(diceName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm delete dice ?"),
            content:
                Text("Do you really want to delete dice " + diceName + " ?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _doDeleteDice(diceName);
                },
                child: Text("Ok"),
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                color: Colors.red,
              )
            ],
          );
        });
  }

  void _doDeleteDice(diceName) {
    setState(() {
      dicesConfiguration.dices.remove(diceName);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dicesComponents =
        dicesConfiguration.dices.entries.map((config) {
      return Row(children: <Widget>[
        Expanded(
          flex: 8,
          child: FlatButton(
              child:
                  Text(config.key, style: Theme.of(context).textTheme.subhead),
              onPressed: () => _selectDice(config.key)),
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
              child: Text("Ed"),
              onPressed: () async {
                final newValues = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiceEditionPage(config.key,
                            dicesConfiguration.dices[config.key].values)));
                var newConfiguration = SingleDiceConfiguration();
                newConfiguration.values = newValues;
                dicesConfiguration.dices[config.key] = newConfiguration;
              }),
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            child: Text("Del"),
            onPressed: () => _deleteDice(config.key),
          ),
        )
      ]);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: dicesComponents,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addDice,
      ),
    );
  }
}
