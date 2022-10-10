import 'package:flutter/material.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class CardButton extends StatelessWidget {
  final String imageName;
  final HorizontalAligment buttonAligment;
  final String text;
  final RectCorner rectCorner;
  final bool isLoading;
  final GestureTapCallback? onTap;

  const CardButton({
    Key? key,
    required this.imageName,
    required this.buttonAligment,
    required this.text,
    required this.rectCorner,
    this.onTap,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final double topLeftRadius = rectCorner == RectCorner.topLeft ? 0 : 20;
    final double topRightRadius = rectCorner == RectCorner.topRight ? 0 : 20;
    final double bottomLeftRadius = rectCorner == RectCorner.bottomLeft ? 0 : 20;
    final double bottomRightRadius = rectCorner == RectCorner.bottomRight ? 0 : 20;

    EdgeInsets aligment = buttonAligment == HorizontalAligment.right ? const EdgeInsets.only(left: 10, right: 0, bottom: 5) : const EdgeInsets.only(right: 10, left: 0, bottom: 5);

    var borderRadius = BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(topRightRadius),
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius));

    return Card(
      shadowColor: customColors.titleColor,
      elevation: 30,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(side: BorderSide(color: customColors.cardBorderColor!, width: 2), borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(imageName), fit: BoxFit.cover),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(margin: aligment, child: CustomButton(text: text, color: Colors.white, opacity: 0.7, isLoading: isLoading, onTap: onTap))),
          ],
        ),
      ),
    );
  }
}

enum HorizontalAligment { left, right }

enum RectCorner { topLeft, topRight, bottomLeft, bottomRight }
