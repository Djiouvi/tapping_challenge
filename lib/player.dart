import 'dart:async';

class Player {
  int remainingTime;
  late Timer timer;

  Player({required this.remainingTime}) {
    timer = Timer(const Duration(milliseconds: 1), () {});
  }

  dynamic get remainingSeconds {
    var d = remainingTime / 100;
    if (d <= 0) return 0;
    return d;
  }
}
