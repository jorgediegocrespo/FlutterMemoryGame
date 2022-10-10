import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class GameOverPage extends StatelessWidget {
  final Object? arguments;

  const GameOverPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameOverWidget(arguments: arguments);
  }
}

class GameOverWidget extends StatelessWidget {
  final Object? arguments;

  const GameOverWidget({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameWon = arguments! as bool;
    final texts = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;
    
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                customColors.backgroundOne!,
                customColors.backgroundTwo!,
              ]),
        ),
      height: 450,
      child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const _CloseButton(),
                  Lottie.asset('assets/json/${gameWon ? 'win.json' : 'lose.json'}', height: 150, repeat: true),
                  const SizedBox(height: 10),
                  _Texts(gameWon: gameWon), 
                  CustomButton(
                          text: texts.playAgain,
                          color: customColors.buttonColor!,
                          opacity: 0,
                          isLoading: false,
                          onTap: () {
                            Navigator.pop(context);
                          })
                  ]),
          )),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    Key? key,
    required this.gameWon
  }) : super(key: key);

  final bool gameWon;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleText(text: gameWon ? texts.gameWonTitle : texts.gameLoseTitle),
              SubtitleText(text: gameWon ? texts.gameWonSubtitle : texts.gameLoseSubtitle)
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatefulWidget {
  const _CloseButton({
    Key? key,
  }) : super(key: key);

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool isNavigatingBack = false;

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Align(
        alignment: Alignment.topRight,
        child: RoundedButton(
            isLoading: isNavigatingBack,
            color: customColors.buttonColor!,
            iconData: Icons.close,
            onTap: () {
              setState(() {
                isNavigatingBack = true;
              });

              Navigator.popUntil(context, (route) => route.isFirst);

              setState(() {
                isNavigatingBack = false;
              });
            }));
  }
}
