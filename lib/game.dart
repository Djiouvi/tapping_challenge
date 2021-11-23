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
}
