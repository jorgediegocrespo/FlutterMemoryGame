import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/helpers/dialog_helper.dart';
import 'package:flutter_memory_game/models/models.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class GamePage extends StatelessWidget {
  final Object? arguments;
  const GamePage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return GameProvider(
            vsync: VsyncProvider.of(context),
            gameInfo: arguments! as GameInfo,
            showGameOver: (gameWon) => finishGame(context, gameWon));
      },
      child: GameWidget(arguments: arguments),
    );
  }

  Future finishGame(BuildContext context, bool gameWon) async {
    await showDialog(
        barrierDismissible: false, context: context, builder: (context) => AlertDialog(contentPadding: const EdgeInsets.all(0), content: GameOverPage(arguments: gameWon)));
  }
}

class GameWidget extends StatelessWidget {
  final Object? arguments;

  const GameWidget({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Background(
            child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const _BackButton(),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: const [
            _PairsCard(),
            SizedBox(width: 5),
            _AttempsCard(),
            SizedBox(width: 5),
            _RemainingTimeCard(),
          ],
        ),
        const SizedBox(height: 10),
        const Expanded(child: _Board())
      ],
    )));
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final texts = AppLocalizations.of(context)!;

    return Align(
        alignment: Alignment.topLeft,
        child: AnimatedBuilder(
            animation: gameProvider.backAnimation,
            builder: (BuildContext _, Widget? __) {
              return Opacity(
                  opacity: gameProvider.backAnimation.value,
                  child: RoundedButton(
                    isLoading: gameProvider.isNavigatingBack,
                    color: customColors.buttonColor!,
                    iconData: Icons.arrow_back,
                    onTap: () async {
                      gameProvider.isNavigatingBack = true;
                      bool goBack = await DialogHelper.showAlertDialog(context, texts.gameBackQuestionTitle, texts.gameBackQuestionMessage, texts.ok, texts.cancel);
                      if (!goBack) {
                        return;
                      }
                      gameProvider.animationController.reverse().whenCompleteOrCancel(() {
                        Navigator.pop(context);
                        gameProvider.isNavigatingBack = false;
                      });
                    },
                  ));
            }));
  }
}

class _PairsCard extends StatelessWidget {
  const _PairsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return _SummaryCard(
        animation: gameProvider.pairsAnimation,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Selector<GameProvider, int>(
              builder: ((_, value, __) => Text(value.toString(), style: TextStyle(fontSize: 22, color: customColors.secondaryColor!))),
              selector: (_, provider) => provider.cardPairsFound),
          const SizedBox(height: 5),
          Text(texts.gamePairs),
        ]));
  }
}

class _AttempsCard extends StatelessWidget {
  const _AttempsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return _SummaryCard(
        animation: gameProvider.attempsAnimation,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Selector<GameProvider, int>(
              builder: ((_, value, __) => Text(value.toString(), style: TextStyle(fontSize: 22, color: customColors.tertiaryColor!))),
              selector: (_, provider) => provider.attempsNumber),
          const SizedBox(height: 5),
          Text(texts.gameAttemps),
        ]));
  }
}

class _RemainingTimeCard extends StatelessWidget {
  const _RemainingTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return _SummaryCard(
      animation: gameProvider.timerAnimation,
      child: Selector<GameProvider, Duration>(
          builder: ((_, value, __) {
            final percentage = value.inSeconds * 100 / provider.totalTime.inSeconds;
            String strDigits(int n) => n.toString().padLeft(2, '0');
            final minutes = strDigits(value.inMinutes.remainder(60));
            final seconds = strDigits(value.inSeconds.remainder(60));

            return Stack(
              children: [
                Center(child: Text('$minutes:$seconds', style: const TextStyle(fontSize: 10))),
                Center(
                    child: CustomPaint(
                        size: const Size.fromRadius(30),
                        painter: CirclePainter(backgroundColor: Colors.black38, lineWidth: 3.0, progressPercentage: percentage, progressColor: customColors.chartColor!)))
              ],
            );
          }),
          selector: (_, provider) => provider.remainingTime),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const _SummaryCard({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Expanded(
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext _, Widget? __) {
            return Opacity(
                opacity: animation.value,
                child: Card(
                  shadowColor: customColors.titleColor,
                  elevation: 10,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(side: BorderSide(color: customColors.cardBorderColor!, width: 2), borderRadius: BorderRadius.circular(10.0)),
                  child: SizedBox(height: 75, child: ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Container(color: customColors.backgroundOne!, child: child))),
                ));
          }),
    );
  }
}

class _Board extends StatelessWidget {
  const _Board({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 250;
    final width = MediaQuery.of(context).size.width - 10;
    final provider = Provider.of<GameProvider>(context, listen: false);
    final aspectRatio = ((width / provider.columnCount) - 10) / (height / provider.rowCount);
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return AnimatedBuilder(
        animation: gameProvider.boardAnimation,
        builder: (BuildContext _, Widget? __) {
          return Opacity(
              opacity: gameProvider.boardAnimation.value,
              child: Selector<GameProvider, List<List<CardInfo?>>>(
                  selector: (_, provider) => provider.board,
                  builder: (_, value, __) {
                    return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: aspectRatio, crossAxisCount: provider.columnCount, mainAxisSpacing: 5, crossAxisSpacing: 5),
                        itemCount: provider.rowCount * provider.columnCount,
                        itemBuilder: (BuildContext context, int index) {
                          final int row = index ~/ provider.columnCount;
                          final int column = (index % provider.columnCount).toInt();
                          provider.boardControllers![row][column].hideCard();

                          return GestureDetector(
                              onTap: () => provider.showCard(row, column, provider.boardControllers![row][column]),
                              child: GameCard(controller: provider.boardControllers![row][column], imageName: "assets/images/${value[row][column]!.imagePath}"));
                        });
                  }));
        });
  }
}
