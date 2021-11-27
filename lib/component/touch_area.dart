import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapping/player.dart';

class TouchArea extends StatelessWidget {
  const TouchArea(
      {Key? key,
      required this.player,
      required this.startTimer,
      this.flex = 4,
      this.color = Colors.amber})
      : super(key: key);

  final int flex;
  final Player? player;
  final Function startTimer;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => startTimer,
        child: Container(
          color: color,
          child: Center(
            child: Text(
              "${player?.remainingSeconds}",
            ),
          ),
        ),
      ),
    );
  }
}
