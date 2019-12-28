import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  LocaleeditDice _editDice;
  LocaleeditDice get editDice => _editDice;
  Localehome _home;
  Localehome get home => _home;
  Localemain _main;
  Localemain get main => _main;
  LocaleplayDice _playDice;
  LocaleplayDice get playDice => _playDice;

  void initAll() {
    _editDice = LocaleeditDice(Map<String, String>.from(_data['editDice']));
    _home = Localehome(Map<String, String>.from(_data['home']));
    _main = Localemain(Map<String, String>.from(_data['main']));
    _playDice = LocaleplayDice(Map<String, String>.from(_data['playDice']));
  }
}

class LocaleeditDice {
  final Map<String, String> _data;
  LocaleeditDice(this._data);

  String get emptyDiceTitle => _data["emptyDiceTitle"];
  String get emptyDiceMessage => _data["emptyDiceMessage"];
  String get sampleValue => _data["sampleValue"];
  String get pageTitle => _data["pageTitle"];
  String get updateButton => _data["updateButton"];
  String get resetButton => _data["resetButton"];
  String get cancelButton => _data["cancelButton"];
}
class Localehome {
  final Map<String, String> _data;
  Localehome(this._data);

  String get diceAlreadyPresentTitle => _data["diceAlreadyPresentTitle"];
  String get diceAlreadyPresentMsg => _data["diceAlreadyPresentMsg"];
  String get chooseDiceName => _data["chooseDiceName"];
  String get confirmDeleteDiceTitle => _data["confirmDeleteDiceTitle"];
  String get confirmDeleteDiceMessage => _data["confirmDeleteDiceMessage"];
  String get loadingConfigurationFailure => _data["loadingConfigurationFailure"];
  String get savingConfigurationFailure => _data["savingConfigurationFailure"];
  String get noDiceNameTitle => _data["noDiceNameTitle"];
  String get noDiceNameMessage => _data["noDiceNameMessage"];
}
class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String get appTitle => _data["appTitle"];
  String get ok => _data["ok"];
  String get cancel => _data["cancel"];
  String get tap => _data["tap"];
}
class LocaleplayDice {
  final Map<String, String> _data;
  LocaleplayDice(this._data);

  String get playingDice => _data["playingDice"];
}
