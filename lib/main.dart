import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'game_screen.dart';

void main() {
  runApp(ArkanoidGame());
}

class ArkanoidGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arkanoid Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/game': (context) => GameScreen(),
      },
    );
  }
}
