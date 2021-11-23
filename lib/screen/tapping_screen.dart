import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapping/game.dart';
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

  var game = Game();

  void startTimer(Player currentPlayer, Player nextPlayer) {
    if (currentPlayer.timer.isActive) {
      currentPlayer.timer.cancel();
      startTimer(nextPlayer, currentPlayer);
    } else {
      if (!nextPlayer.timer.isActive) {
        runningCountdown(currentPlayer);
      }
    }
  }

  void runningCountdown(Player? player) {

    //Si jeu est en pause (running à false) et que la personne qui redemarre n'est pas la bonne
    // si le jeu est fini
    if((game.currentPlayer != null && game.currentPlayer != player && !game.running) || game.endGame) {
      return;
    }

    game.running = true;
    game.currentPlayer = player;

    player?.timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) {
        //Si le temps tombe à 0 alors stop
        if (player.remainingTime == 0) {
          setState(() {
            game.running = false;
            game.endGame = true;
            timer.cancel();
          });
        }

        //Pause
         else if (!game.running && timer.isActive) {
          setState(() {
            timer.cancel();
          });
        } else {
          //Le jeu classique
          setState(() {
            if (!game.running) {
              game.running = true;
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
                        game.running = !game.running;

                        //Si pause -> relance le joueur
                        if(game.running) {
                          runningCountdown(game.currentPlayer);
                        }
                      });
                    },
                    icon: Icon(game.running ? Icons.pause : Icons.play_arrow),
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
