import 'package:flutter/material.dart';

import 'dice.dart';
import 'generated/locale_base.dart';
import 'utils.dart';

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
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      appBar: AppBar(
        title: Text(replaceVariables(loc.playDice.playingDice, {"diceName": diceName})),
      ),
      body: SizedBox(
        child: FlatButton(
          child: Center(
            child: _dice,
          ),
          onPressed: () => _dice.launch(),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
