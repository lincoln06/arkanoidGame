import 'package:flutter/material.dart';
import 'game_logic.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late GameLogic gameLogic;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic(onGameOver: onGameOver, onGameWon: onGameWon, onLifeLost: onLifeLost);
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 16))
      ..addListener(() {
        setState(() {
          gameLogic.update();
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onGameOver() {
    _controller.stop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Koniec gry'),
        content: Text('Utraciłeś wszystkie życia.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Wyjście do menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                gameLogic.resetGame();
                _controller.repeat();
              });
            },
            child: Text('Zagraj ponownie'),
          ),
        ],
      ),
    );
  }

  void onGameWon() {
    _controller.stop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wygrałeś!'),
        content: Text('Gratulacje!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Wyjście do menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                gameLogic.resetGame();
                _controller.repeat();
              });
            },
            child: Text('Zagraj ponownie'),
          ),
        ],
      ),
    );
  }

  void onLifeLost() {
    _controller.stop();
    int countdown = 3;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(Duration(seconds: 1), () {
              if (countdown > 0) {
                setState(() {
                  countdown--;
                });
              } else {
                Navigator.of(context).pop();
                _controller.repeat();
              }
            });

            return AlertDialog(
              title: Text('Spróbuj ponownie!'),
              content: Text('Wznowienie za $countdown sekund...'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _controller.repeat();
                  },
                  child: Text('Wznów!'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              _controller.stop();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return  AlertDialog(
                    content: Text('Gra została zatrzymana'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _controller.repeat();
                        },
                        child: Text('Wznów'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          gameLogic.initialize(constraints.maxWidth, constraints.maxHeight - 80);
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Poziom: ${gameLogic.level}'),
                    Text('Życia: ${gameLogic.lives}'),
                  ],
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    gameLogic.movePaddle(details.primaryDelta!);
                  },
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight - 80),
                    painter: GamePainter(gameLogic),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final GameLogic gameLogic;

  GamePainter(this.gameLogic);

  @override
  void paint(Canvas canvas, Size size) {
    gameLogic.updateSize(size);

    // Rysowanie piłeczki
    canvas.drawCircle(gameLogic.ballPosition, gameLogic.ballRadius, Paint()..color = Colors.blue);

    // Rysowanie paletki
    canvas.drawRect(gameLogic.paddleRect, Paint()..color = Colors.black);

    // Rysowanie klocków
    for (var brick in gameLogic.bricks) {
      canvas.drawRect(brick.rect, Paint()..color = brick.color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
