import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/models/models.dart';
import 'package:flutter_memory_game/router/routes.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class LevelSelectorPage extends StatelessWidget {
  final Object? arguments;

  const LevelSelectorPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LevelSelectorProvider(vsync: VsyncProvider.of(context)),
      child: LevelSelectorWidget(arguments: arguments),
    );
  }
}

class LevelSelectorWidget extends StatelessWidget {
  final Object? arguments;

  const LevelSelectorWidget({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelSelectorProvider = Provider.of<LevelSelectorProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;
    final gameInfo = arguments! as GameInfo;

    return Scaffold(
        body: Background(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        const _BackButton(),
        const _Title(),
        const SizedBox(height: 50),
        _AnimatedButton(
            animation: levelSelectorProvider.lowAnimation,
            updateNavigating: (x) => levelSelectorProvider.isNavigatingLow = x,
            selector: (_, provider) => provider.isNavigatingLow,
            text: texts.lowLevel,
            gameInfo: gameInfo,
            level: Levels.low),
        const SizedBox(height: 10),
        _AnimatedButton(
            animation: levelSelectorProvider.mediumAnimation,
            updateNavigating: (x) => levelSelectorProvider.isNavigatingMedium = x,
            selector: (_, provider) => provider.isNavigatingMedium,
            text: texts.mediumLevel,
            gameInfo: gameInfo,
            level: Levels.medium),
        const SizedBox(height: 10),
        _AnimatedButton(
            animation: levelSelectorProvider.highAnimation,
            updateNavigating: (x) => levelSelectorProvider.isNavigatingHigh = x,
            selector: (_, provider) => provider.isNavigatingHigh,
            text: texts.highLevel,
            gameInfo: gameInfo,
            level: Levels.high),
        const Expanded(child: SizedBox())
      ]),
    ));
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelSelectorProvider = Provider.of<LevelSelectorProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;

    return Expanded(
        child: Center(
            child: AnimatedBuilder(
      animation: levelSelectorProvider.labelAnimation,
      builder: (BuildContext _, Widget? __) {
        return Opacity(opacity: levelSelectorProvider.labelAnimation.value, child: TitleText(text: texts.levelSelectorTitle));
      },
    )));
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelSelectorProvider = Provider.of<LevelSelectorProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Align(
        alignment: Alignment.topLeft,
        child: AnimatedBuilder(
            animation: levelSelectorProvider.backAnimation,
            builder: (BuildContext _, Widget? __) {
              return Opacity(
                  opacity: levelSelectorProvider.backAnimation.value,
                  child: RoundedButton(
                    isLoading: levelSelectorProvider.isNavigatingBack,
                    color: customColors.buttonColor!,
                    iconData: Icons.arrow_back,
                    onTap: () {
                      levelSelectorProvider.isNavigatingBack = true;
                      levelSelectorProvider.animationController.reverse().whenCompleteOrCancel(() {
                        Navigator.pop(context);
                        levelSelectorProvider.isNavigatingBack = false;
                      });
                    },
                  ));
            }));
  }
}

class _AnimatedButton extends StatelessWidget {
  final Animation<double> animation;
  final void Function(bool) updateNavigating;
  final bool Function(BuildContext, LevelSelectorProvider) selector;
  final String text;
  final Levels level;
  final GameInfo gameInfo;

  const _AnimatedButton({
    Key? key,
    required this.animation,
    required this.updateNavigating,
    required this.selector,
    required this.text,
    required this.level,
    required this.gameInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelSelectorProvider = Provider.of<LevelSelectorProvider>(context, listen: false);
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return SizedBox(
        width: 150,
        child: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext _, Widget? __) {
              return Opacity(
                  opacity: animation.value,
                  child: Selector<LevelSelectorProvider, bool>(
                      selector: selector,
                      builder: ((_, value, __) => CustomButton(
                          text: text,
                          color: customColors.buttonColor!,
                          opacity: 0,
                          isLoading: value,
                          onTap: () {
                            updateNavigating(true);
                            levelSelectorProvider.animationController.reverse().whenCompleteOrCancel(() {
                              gameInfo.level = level;
                              Navigator.pushNamed(context, Routes.game, arguments: gameInfo).then((value) => levelSelectorProvider.animationController.forward());
                              updateNavigating(false);
                            });
                          }))));
            }));
  }
}
