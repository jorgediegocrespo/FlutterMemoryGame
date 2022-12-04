import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/features/gameOver/game_over_provider.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class GameOverPage extends StatelessWidget {
  final Object? arguments;

  const GameOverPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameOverProvider(gameWon: arguments! as bool),
      child: const GameOverWidget(),
    );
  }
}

class GameOverWidget extends StatelessWidget {
  final Object? arguments;

  const GameOverWidget({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameOverProvider = Provider.of<GameOverProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[
          customColors.backgroundOne!,
          customColors.backgroundTwo!,
        ]),
      ),
      height: 450,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const _CloseButton(),
          Lottie.asset('assets/json/${gameOverProvider.gameWon ? 'win.json' : 'lose.json'}', height: 150, repeat: true),
          const SizedBox(height: 10),
          _Texts(gameWon: gameOverProvider.gameWon),
          const _PlayAgainButton()
        ]),
      )),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({Key? key, required this.gameWon}) : super(key: key);

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
            children: [TitleText(text: gameWon ? texts.gameWonTitle : texts.gameLoseTitle), SubtitleText(text: gameWon ? texts.gameWonSubtitle : texts.gameLoseSubtitle)],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final gameOverProvider = Provider.of<GameOverProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Align(
        alignment: Alignment.topRight,
        child: Selector<GameOverProvider, bool>(
            selector: (_, provider) => provider.isClosing,
            builder: ((_, value, __) => RoundedButton(isLoading: value, color: customColors.buttonColor!, iconData: Icons.close, onTap: () => gameOverProvider.close()))));
  }
}

class _PlayAgainButton extends StatelessWidget {
  const _PlayAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    final gameOverProvider = Provider.of<GameOverProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Selector<GameOverProvider, bool>(
        selector: (_, provider) => provider.isNavigatingToPlayAgain,
        builder: ((_, value, __) =>
            CustomButton(text: texts.playAgain, color: customColors.buttonColor!, opacity: 0, isLoading: value, onTap: () => gameOverProvider.playAgain())));
  }
}
