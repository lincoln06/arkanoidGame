import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class GameLogic {
  final Function onGameOver;
  final Function onGameWon;
  final Function onLifeLost;

  final List<Color> brickColors = [
    Colors.lightGreenAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightBlueAccent,
    Colors.lightBlue,
    Colors.blue,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.deepOrangeAccent,
    Colors.red
  ];

  int level = 1;
  int lives = 3;
  double ballSpeed = 3.0;
  Offset ballPosition = Offset(200, 400);
  Offset ballDirection = Offset(1, -1);
  double ballRadius = 10.0;
  Rect paddleRect = Rect.fromLTWH(150, 450, 100, 20);
  List<Brick> bricks = [];
  Size? screenSize;
  late AudioPlayer _audioPlayer;

  GameLogic({required this.onGameOver, required this.onGameWon, required this.onLifeLost}) {
    _audioPlayer = AudioPlayer();
  }

  void initialize(double width, double height) {
    if (screenSize == null) {
      screenSize = Size(width, height);
      ballPosition = Offset(screenSize!.width / 2, screenSize!.height - 30);
      paddleRect = Rect.fromLTWH((screenSize!.width - 100) / 2, screenSize!.height - 40, 100, 20);
      _createBricks();
    }
  }

  void updateSize(Size size) {
    if (screenSize == null) {
      screenSize = size;
      ballPosition = Offset(screenSize!.width / 2, screenSize!.height - 30);
      paddleRect = Rect.fromLTWH((screenSize!.width - 100) / 2, screenSize!.height - 40, 100, 20);
      _createBricks();
    }
  }

  void resetGame() {
    level = 1;
    lives = 3;
    ballSpeed = 3.0;
    ballPosition = Offset(screenSize!.width / 2, screenSize!.height - 30);
    ballDirection = Offset(1, -1);
    paddleRect = Rect.fromLTWH((screenSize!.width - 100) / 2, screenSize!.height - 40, 100, 20);
    _createBricks();
  }

  void _createBricks() {
    bricks.clear();
    double brickWidth = screenSize!.width / 10;
    double brickHeight = screenSize!.height / 20;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 10; j++) {
        bricks.add(Brick(
          rect: Rect.fromLTWH(j * brickWidth, i * brickHeight + 50, brickWidth - 5, brickHeight - 5),
            color: brickColors[(level % 10) - 1]
        ));
      }
    }
  }

  void update() {
    // Aktualizacja pozycji piłeczki
    ballPosition += ballDirection * ballSpeed;

    // Wykrywanie kolizji
    if (ballPosition.dx - ballRadius <= 0 || ballPosition.dx + ballRadius >= screenSize!.width) {
      ballDirection = Offset(-ballDirection.dx, ballDirection.dy);
    }
    if (ballPosition.dy - ballRadius <= 0) {
      ballDirection = Offset(ballDirection.dx, -ballDirection.dy);
    }
    if (ballPosition.dy + ballRadius >= screenSize!.height) {
      lives--;
      if (lives == 0) {
        playSound("game_over");
        onGameOver();
      } else {
        playSound("life_lost");
        onLifeLost();
        ballPosition = Offset(200, 400);
        ballDirection = Offset(1, -1);
      }
    }

    // Sprawdzanie, czy nastąpiła kolizja z "paletką"
    if (ballPosition.dy + ballRadius >= paddleRect.top &&
        ballPosition.dy + ballRadius <= paddleRect.bottom &&
        ballPosition.dx >= paddleRect.left &&
        ballPosition.dx <= paddleRect.right) {
      playSound("collision");
      ballDirection = Offset(ballDirection.dx, -ballDirection.dy);
    }

    // Sprawdzanie, czy klocek został zbity
    for (var brick in bricks) {
      if (ballPosition.dx >= brick.rect.left &&
          ballPosition.dx <= brick.rect.right &&
          ballPosition.dy - ballRadius <= brick.rect.bottom &&
          ballPosition.dy + ballRadius >= brick.rect.top) {
        bricks.remove(brick);
        playSound("collision");
        ballDirection = Offset(ballDirection.dx, -ballDirection.dy);
        break;
      }
    }

    // Sprawdzanie, czy wszystkie klocki zostały zbite
    if (bricks.isEmpty) {
      level++;
      if (level > 30) {
        playSound("you_won");
        onGameWon();
      } else {
        playSound("level_up");
        if (level % 10 == 0) {
          lives++;
        }
        ballSpeed *= 1.05;
        ballPosition = Offset(screenSize!.width / 2, screenSize!.height - 30);
        ballDirection = Offset(1, -1);
        _createBricks();
      }
    }
  }

  void movePaddle(double delta) {
    double newLeft = paddleRect.left + delta;
    if (newLeft >= 0 && newLeft + paddleRect.width <= screenSize!.width) {
      paddleRect = paddleRect.shift(Offset(delta, 0));
    }
  }

  void playSound(String soundName) async {
    String path = "../assets/sounds/$soundName.wav";
    await _audioPlayer.play(AssetSource(path));
    print(path);
  }
}

class Brick {
  Rect rect;
  Color color;

  Brick({required this.rect, required this.color});
}
