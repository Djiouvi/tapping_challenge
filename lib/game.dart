import 'package:tapping/player.dart';

class Game {
  bool running;
  Player? currentPlayer;

  Game({
    this.running = false,
    this.currentPlayer,
  });
}
