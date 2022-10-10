import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? backgroundOne;
  final Color? backgroundTwo;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? cardBackgroundColor;
  final Color? cardBorderColor;
  final Color? titleColor;
  final Color? secondaryColor;
  final Color? tertiaryColor;
  final Color? chartColor;
  final Color? shadowColor;

  const CustomColors(
      {this.backgroundOne,
      this.backgroundTwo,
      this.buttonColor,
      this.buttonTextColor,
      this.cardBackgroundColor,
      this.cardBorderColor,
      this.titleColor,
      this.secondaryColor,
      this.tertiaryColor,
      this.chartColor,
      this.shadowColor});

  @override
  CustomColors copyWith({
    Color? backgroundOne,
    Color? backgroundTwo,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? cardBackgroundColor,
    Color? cardBorderColor,
    Color? titleColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    Color? chartColor,
    Color? shadowColor,
  }) {
    return CustomColors(
      backgroundOne: backgroundOne ?? this.backgroundOne,
      backgroundTwo: backgroundTwo ?? this.backgroundTwo,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      cardBackgroundColor: cardBackgroundColor ?? this.cardBackgroundColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      titleColor: titleColor ?? this.titleColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      chartColor: chartColor ?? this.chartColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      backgroundOne: Color.lerp(backgroundOne, other.backgroundOne, t),
      backgroundTwo: Color.lerp(backgroundTwo, other.backgroundTwo, t),
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t),
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t),
      cardBackgroundColor: Color.lerp(cardBackgroundColor, other.cardBackgroundColor, t),
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t),
      titleColor: Color.lerp(titleColor, other.titleColor, t),
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t),
      chartColor: Color.lerp(chartColor, other.chartColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
    );
  }

  static const light = CustomColors(
    backgroundOne: Color(0xffFFFFFF),
    backgroundTwo: Color(0xffADD8E6),
    buttonColor: Color(0xff4C4CAD),
    buttonTextColor: Color(0xffFFFFFF),
    cardBackgroundColor: Color(0xff4C4CAD),
    cardBorderColor: Color(0xff4C4CAD),
    titleColor: Color(0xff000000),
    secondaryColor: Color(0xffad4c4c),
    tertiaryColor: Color(0xff4cad4c),
    chartColor: Color(0xff4C4CAD),
    shadowColor: Colors.black45,
  );

  static const dark = CustomColors(
    backgroundOne: Color(0xff000000),
    backgroundTwo: Color(0xff522719),
    buttonColor: Color(0xffFFFFFF),
    buttonTextColor: Color(0xffFFFFFF),
    cardBackgroundColor: Color(0xff4C4CAD),
    cardBorderColor: Color(0xffFFFFFF),
    titleColor: Color(0xffFFFFFF),
    secondaryColor: Color(0xffad4c4c),
    tertiaryColor: Color(0xff4cad4c),
    chartColor: Color(0xff4C4CAD),
    shadowColor: Colors.white10
  );
}
