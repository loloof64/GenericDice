import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'generated/locale_base.dart';

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

  // used snippet https://stackoverflow.com/a/51734013/662618

  Animation<Color> _animation;
  AnimationController _animationController;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 280), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animation =
        ColorTween(begin: Colors.white, end: Colors.red).animate(curve);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  void _launch() async {
    await _animationController.forward();
    final selectedIndex = _rng.nextInt(values.length);
    setState(() {
      _value = values[selectedIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final valueStr = _value ?? loc.main.tap;
    return Container(
      color: _animation.value,
      child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
          child: Center(
            child: GestureDetector(
              child: Text(
                '$valueStr',
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          )),
    );
  }
}
