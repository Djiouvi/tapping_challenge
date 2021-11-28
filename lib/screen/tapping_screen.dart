import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapping/component/touch_area.dart';
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
  var game = Game();

  var player1 = Player(remainingTime: TappingScreen.defaultRemainingTime);
  var player2 = Player(remainingTime: TappingScreen.defaultRemainingTime);

  void startTimer(Player currentPlayer, Player nextPlayer) {
    if (currentPlayer.timer.isActive) {
      currentPlayer.timer.cancel();
      startTimer(nextPlayer, currentPlayer);
    } else {
      if (!nextPlayer.timer.isActive) {
        runningCountdown(currentPlayer);
      } else {
        losingLife(currentPlayer);
      }
    }
  }

  void runningCountdown(Player? player) {
    //Si jeu est en pause (running à false) et que la personne qui redemarre n'est pas la bonne
    // si le jeu est fini
    if ((game.currentPlayer != null &&
            game.currentPlayer != player &&
            !game.running) ||
        game.endGame) {
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
            game.gameOver();
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

  void losingLife(Player nextPlayer) {
    setState(() {
      nextPlayer.losingLife(game);
    });
  }

  void resetGame() {
    setState(() {
      game = Game();
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
            TouchArea(
                flex: 4,
                player: player1,
                color: Colors.amber,
                startTimer: () {
                  setState(() {
                    startTimer(player1, player2);
                  });
                }),
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
                        if (game.running) {
                          runningCountdown(game.currentPlayer);
                        }
                      });
                    },
                    icon: Icon(game.running ? Icons.pause : Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      resetGame();
                    },
                    icon: const Icon(Icons.restart_alt),
                  ),
                ],
              ),
              flex: 1,
            ),
            TouchArea(
              flex: 4,
              player: player2,
              color: Colors.amber,
              startTimer: () {
                setState(() {
                  startTimer(player2, player1);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
