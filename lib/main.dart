import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dice_configuration.dart';
import 'dice_edition.dart';
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
  final key = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    diceNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadConfigurationFromFile();
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

  void _saveConfigurationToFile() {
    final jsonConfig = jsonEncode(dicesConfiguration);
    getApplicationDocumentsDirectory().then((homeDirectory) {
      final fileContext = p.Context(style: p.Style.platform);
      final configPath = fileContext.join(homeDirectory.path, 'config');
      new Directory(configPath).create().then((Directory configDirectory) {
        final filePath = p.join(configPath, 'dices.txt');
        final configFile = File(filePath);
        configFile.writeAsStringSync(jsonConfig);
      });
    }).catchError((error) {
      print(error);
      key.currentState?.showSnackBar(new SnackBar(
        content: new Text("Failed to save configuration !"),
      ));
    });
  }

  void _loadConfigurationFromFile() {
    getApplicationDocumentsDirectory().then((homeDirectory) {
      final fileContext = p.Context(style: p.Style.platform);
      final configFilePath =
          fileContext.join(homeDirectory.path, 'config', 'dices.txt');
      final configFile = File(configFilePath);
      final jsonConfig = configFile.readAsStringSync();
      final Map<String, dynamic> rawJson = jsonDecode(jsonConfig);
      final dicesConfiguration = UserDicesConfiguration.fromJson(rawJson);
      setState(() {
        this.dicesConfiguration = dicesConfiguration;
      });
    }).catchError((error) {
      print(error);
      key.currentState.showSnackBar(new SnackBar(
        content: new Text("Failed to load configuration !"),
      ));
    });
  }

  void _createDice(String diceName) {
    var configuration = <String>[];
    if (dicesConfiguration.dices.containsKey(diceName)) {
      _showErrorDialog(diceName);
      return;
    }
    setState(() {
      configuration = ["1", "2", "3", "4", "5", "6"];
      dicesConfiguration.dices[diceName] = configuration;

      _saveConfigurationToFile();
    });
    Navigator.pop(context);
  }

  void _selectDice(String diceName) {
    final values = dicesConfiguration.dices[diceName];
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
        dicesConfiguration.dices?.entries?.map((config) {
              return Row(children: <Widget>[
                Expanded(
                  flex: 8,
                  child: FlatButton(
                      child: Text(config.key,
                          style: Theme.of(context).textTheme.subhead),
                      onPressed: () => _selectDice(config.key)),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                      child: Transform.scale(
                        scale: 1.2,
                        child: Tab(
                          icon: Image.asset('assets/images/edit.png'),
                        ),
                      ),
                      onPressed: () async {
                        final newValues = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiceEditionPage(
                                    config.key,
                                    dicesConfiguration.dices[config.key])));
                        dicesConfiguration.dices[config.key] = newValues;
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: FlatButton(
                    child: Transform.scale(
                      scale: 1.2,
                      child: Tab(
                        icon: Image.asset('assets/images/delete.png'),
                      ),
                    ),
                    onPressed: () => _deleteDice(config.key),
                  ),
                )
              ]);
            })?.toList() ??
            <Widget>[];

    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.play_arrow),
            onPressed: _loadConfigurationFromFile,
          )
        ],
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
