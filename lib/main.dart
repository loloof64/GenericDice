import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dice_configuration.dart';
import 'dice_edition.dart';
import 'dice_play.dart';
import 'generated/locale_base.dart';
import 'localedelegate.dart';

import 'package:devicelocale/devicelocale.dart';

import 'utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getAppTitleAync().then((title) {
    runApp(MyApp(title));
  }).catchError((err) {
    print(err);
    runApp(MyApp('Generic dice'));
  });
}

Future<String> getAppTitleAync() async {
  try {
    final currentLocaleStr = await Devicelocale.currentLocale;
    final currentLocale = Locale.fromSubtags(languageCode: currentLocaleStr);
    final localeDelegate = LocDelegate();
    final localeBase = await localeDelegate.load(currentLocale);
    return localeBase.main.appTitle;
  } catch (err) {
    print(err);
    return 'Generic Dice';
  }
}

class MyApp extends StatelessWidget {
  final String title;

  MyApp(this.title);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          const LocDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('fr'),
        ],
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadConfigurationFromFile());
  }

  void _showNoDiceNameErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final loc = Localizations.of<LocaleBase>(context, LocaleBase);
          return AlertDialog(
            title: Text(loc.home.noDiceNameTitle),
            content: Text(loc.home.noDiceNameMessage),
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
  }

  void _showDiceAlreadyThereErrorDialog(diceName) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final loc = Localizations.of<LocaleBase>(context, LocaleBase);
          return AlertDialog(
            title: Text(loc.home.diceAlreadyPresentTitle),
            content: Text(replaceVariables(
                loc.home.diceAlreadyPresentMsg, {"diceName": diceName})),
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
  }

  void _saveConfigurationToFile() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
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
        content: new Text(loc.home.savingConfigurationFailure),
      ));
    });
  }

  void _loadConfigurationFromFile() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
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
        content: new Text(loc.home.loadingConfigurationFailure),
      ));
    });
  }

  void _createDice(String diceName) {
    var configuration = <String>[];
    if (diceName.trim().length == 0) {
      _showNoDiceNameErrorDialog();
      return;
    }
    if (dicesConfiguration.dices.containsKey(diceName)) {
      _showDiceAlreadyThereErrorDialog(diceName);
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
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(loc.home.chooseDiceName),
            content: TextField(
              controller: diceNameController,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _createDice(diceNameController.text);
                },
                child: Text(loc.main.ok),
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(loc.main.cancel),
                color: Colors.red,
              )
            ],
          );
        });
  }

  void _deleteDice(diceName) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(loc.home.confirmDeleteDiceTitle),
            content: Text(replaceVariables(
                loc.home.confirmDeleteDiceMessage, {"diceName": diceName})),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _doDeleteDice(diceName);
                },
                child: Text(loc.main.ok),
                color: Colors.blue,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(loc.main.cancel),
                color: Colors.red,
              )
            ],
          );
        });
  }

  void _doDeleteDice(diceName) {
    setState(() {
      dicesConfiguration.dices.remove(diceName);
      _saveConfigurationToFile();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
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
                        _saveConfigurationToFile();
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
        title: Text(loc.main.appTitle),
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
