import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_memory_game/themes/colors.dart';

class Background extends StatelessWidget {
  final Widget? child;

  const Background({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final theme = MediaQuery.of(context).platformBrightness;
    
    return AnnotatedRegion<SystemUiOverlayStyle>( 
    value: theme == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark, //To change device top bar icons color
    child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: <Color>[
                customColors.backgroundOne!,
                customColors.backgroundTwo!,
              ]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: child,
          ),
        )));
  }
}
