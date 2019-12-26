import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:soundpool/soundpool.dart';

Soundpool sndPool = Soundpool(streamType: StreamType.music);

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
  int _value = 0;
  int _soundId = -1;
  Random _rng = new Random();

  void _initSound() {
    DefaultAssetBundle.of(context).load("assets/sounds/dice.wav").then((ByteData soundData) {
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

  void _launchDice() {
    setState(() {
      sndPool.play(_soundId).then((result) {});
      Future.delayed(Duration(milliseconds: 600)).then((result) {
        _value = _rng.nextInt(6) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_value',
              style: Theme.of(context).textTheme.display4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchDice,
        tooltip: 'Launch dice',
        child: Icon(Icons.add),
      ),
    );
  }
}
