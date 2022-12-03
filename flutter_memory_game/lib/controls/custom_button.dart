import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final double opacity;
  final Color color;
  final GestureTapCallback? onTap;

  const CustomButton(
      {Key? key, required this.text, this.onTap, required this.isLoading, required this.opacity, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return MaterialButton(
        onPressed: null,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
            color: Colors.black.withOpacity(opacity),
          ),
          child: Center(
              child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: color)),
          )),
      );
    } else {
      return MaterialButton(
        onPressed: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
            color: Colors.black.withOpacity(opacity),
          ),
          child: Center(
              child: Text(
            text,
            style: TextStyle(color: color),
          )),
        ),
      );
    }
  }
}
