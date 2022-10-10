import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.light,
    ],
  );
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      CustomColors.dark,
    ],
  );

  static const titleTextStyle = TextStyle(fontSize: 20);
  static const subtitleTextStyle = TextStyle(fontSize: 14);
}
