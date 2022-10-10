import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  
  final bool isLoading;
  final Color color;
  final IconData iconData;
  final GestureTapCallback? onTap;

  const RoundedButton(
      {Key? key, this.onTap, required this.isLoading, required this.color, required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 40, width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          color: Colors.black.withOpacity(0),
        ),
        child: Center(
            child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: color)),
        ));
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40, width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
            color: Colors.black.withOpacity(0),
          ),
          child: Center(
              child: Icon(iconData, color: color)
          ),
        ),
      );
    }
  }
}
