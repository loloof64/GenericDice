import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'generated/locale_base.dart';

import 'package:animator/animator.dart';

class Dice extends StatefulWidget {
  final List<String> values;

  final _DiceState state;

  Dice(this.values) : state = _DiceState(values);

  void launch() {
    state._launch();
  }

  @override
  _DiceState createState() => state;
}

class _DiceState extends State<Dice> with SingleTickerProviderStateMixin {
  var _value;
  final _rng = new Random();

  final List<String> values;

  _DiceState(this.values);

  Widget _buildAnimator(context, value) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Animator<double>(
      resetAnimationOnRebuild: true,
      triggerOnInit: true,
      tween: Tween<double>(begin: 0, end: 1),
      cycles: 2,
      duration: Duration(milliseconds: 200),
      builder: (anim) => Container(
      color: Colors.red.withOpacity(anim.value),
      child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
          child: Center(
            child: GestureDetector(
              child: Text(
                '${_value ?? loc.main.tap}',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          )),
    )
    );
  }

  void _launch() async {
    final selectedIndex = _rng.nextInt(values.length);
    setState(() {
      _value = values[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimator(context, _value);
  }
}
