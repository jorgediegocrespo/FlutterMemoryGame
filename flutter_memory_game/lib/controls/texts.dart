import 'package:flutter/material.dart';

import 'package:flutter_memory_game/themes/themes.dart';

class TitleText extends StatelessWidget {
  final String text;
  const TitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: AppTheme.titleTextStyle, textAlign: TextAlign.center);
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: AppTheme.subtitleTextStyle, textAlign: TextAlign.center);
  }
}

