import 'dart:async';

import 'package:tapping/game.dart';

//Si totalLife == 0 alors pas de système de vie
class Player {
  int remainingTime;
  num totalLife;
  late num currentLife;
  late Timer timer;

  Player({required this.remainingTime, this.totalLife = 3}) {
    timer = Timer(const Duration(milliseconds: 1), () {});
    currentLife = totalLife;
  }

  dynamic get remainingSeconds {
    var d = remainingTime / 100;
    if (d <= 0) return 0;
    return d;
  }

  void losingLife(Game game) {
    if (totalLife >= 1) {
      currentLife--;
      if (currentLife == 0) {
        game.gameOver();
      }
    }
  }
}
