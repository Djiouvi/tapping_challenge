import 'package:tapping/player.dart';

class Game {
  bool running;
  Player? currentPlayer;
  bool endGame;

  Game({
    this.running = false,
    this.currentPlayer,
    this.endGame = false,
  });

  void gameOver() {
    running = false;
    endGame = true;
  }
}
