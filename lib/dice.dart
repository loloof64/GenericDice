import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Dice extends StatefulWidget {
  final List<String> values;

  Dice(this.values);

  @override
  _DiceState createState() => _DiceState(values);
}

class _DiceState extends State<Dice> with SingleTickerProviderStateMixin {
  var _value = "Tap !";
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
      setState(() {});
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
    return Container(
      color: _animation.value,
      child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: double.infinity, minHeight: double.infinity),
          child: Center(
            child: GestureDetector(
              child: Text(
                '$_value',
                style: Theme.of(context).textTheme.display4,
              ),
              onTap: _launch,
            ),
          )),
    );
  }
}
