import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapping/player.dart';

class TappingScreen extends StatefulWidget {
  const TappingScreen({Key? key}) : super(key: key);

  static const int defaultRemainingTime = 1000;

  @override
  _TappingScreen createState() {
    return _TappingScreen();
  }
}

class _TappingScreen extends State<TappingScreen> {
  var player1 = Player(remainingTime: TappingScreen.defaultRemainingTime);
  var player2 = Player(remainingTime: TappingScreen.defaultRemainingTime);

  bool running = false;

  void startTimer(Player currentPlayer, Player nextPlayer) {
    if (currentPlayer.timer.isActive) {
      currentPlayer.timer.cancel();
      startTimer(nextPlayer, currentPlayer);
    } else {
      if (!nextPlayer.timer.isActive) {
        running = true;
        runningCountdown(currentPlayer);
      }
    }
  }

  void runningCountdown(Player player) {
    player.timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) {
        if (player.remainingTime == 0) {
          setState(() {
            running = false;
            timer.cancel();
          });
        }
        if (!running && timer.isActive) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            if (!running) {
              running = true;
            }
            player.remainingTime--;
          });
        }
      },
    );
  }

  void reset() {
    setState(() {
      player1 = Player(remainingTime: TappingScreen.defaultRemainingTime);
      player2 = Player(remainingTime: TappingScreen.defaultRemainingTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    startTimer(player1, player2);
                  });
                },
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      "${player1.remainingSeconds}",
                    ),
                  ),
                ),
              ),
              flex: 4,
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        running = !running;
                      });
                    },
                    icon: Icon(running ? Icons.pause : Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      reset();
                    },
                    icon: const Icon(Icons.restart_alt),
                  ),
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    startTimer(player2, player1);
                  });
                },
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      "${player2.remainingSeconds}",
                    ),
                  ),
                ),
              ),
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
