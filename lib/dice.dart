import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';

Soundpool sndPool = Soundpool(streamType: StreamType.music);

class Dice extends StatefulWidget {
  Dice({Key key}) : super(key: key);

  final _DiceState state = _DiceState();

  launch() {
    state._launch();
  }

  @override
  _DiceState createState() => state;
}

class _DiceState extends State<Dice> {
  int _value = 0;
  int _soundId = -1;
  Random _rng = new Random();

  void _initSound() {
    DefaultAssetBundle.of(context)
        .load("assets/sounds/dice.wav")
        .then((ByteData soundData) {
      return sndPool.load(soundData);
    }).then((soundId) {
      _soundId = soundId;
    }).catchError((error) {
      print(error);
    });
  }

  void initState() {
    super.initState();
    _initSound();
  }

  void _launch() {
    setState(() {
      sndPool.play(_soundId).then((result) {});
      Future.delayed(Duration(milliseconds: 600)).then((result) {
        _value = _rng.nextInt(6) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '$_value',
            style: Theme.of(context).textTheme.display4,
          ),
        ],
      ),
    );
  }
}
