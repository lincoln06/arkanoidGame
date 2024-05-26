import 'dart:io';

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Center(
            child: Text(
              "Arkanoid Game",
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.blueAccent
              )
            )
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/game');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 5, // Wysokość cienia
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Graj'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              exit(0);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 5, // Wysokość cienia
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Wyjdź'),
          )
        ]),
      ),
    );
  }
}
