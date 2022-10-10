import "dart:math" show pi;

import 'package:flutter/material.dart';

import 'package:flutter_memory_game/themes/colors.dart';

class GameCardController {
  _GameCardState? _state;

  Future flipCard() async {
    await _state?.flipCard();
  }

  Future hideCard() async {
    await _state?.hideCard();
  }
}

class GameCard extends StatefulWidget {
  final GameCardController controller;
  final String imageName;

  const GameCard({Key? key, required this.controller, required this.imageName}) : super(key: key);

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> with TickerProviderStateMixin {
  late AnimationController controller;
  bool isFront = false;

  Future flipCard() async {
    isFront = !isFront;
    if (isFront) {
      await controller.forward();
    } else {
      await controller.reverse();
    }
  }

  Future hideCard() async {
    if (!isFront) {
      return;
    }
    
    isFront = false;
    await controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    widget.controller._state = this;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final angle = controller.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: isFronImage(angle.abs())
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage(widget.imageName), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                )
              : Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: [
                        Container(color: customColors.cardBackgroundColor!),
                      ],
                    ),
                  )),
        );
      });
  }

  bool isFronImage(double angle) {
    const degrees90 = pi / 2;
    const degrees270 = 3 * pi / 2;

    return angle >= degrees90 && angle <= degrees270;
  }
}
