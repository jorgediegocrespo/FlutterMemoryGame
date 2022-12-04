import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/models/models.dart';
import 'package:flutter_memory_game/themes/colors.dart';

class LevelSelectorPage extends StatelessWidget {
  final Object? arguments;

  const LevelSelectorPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LevelSelectorProvider(gameInfo: arguments as GameInfo),
      child: const LevelSelectorWidget(),
    );
  }
}

class LevelSelectorWidget extends StatelessWidget {
  const LevelSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelSelectorProvider = Provider.of<LevelSelectorProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;

    return Scaffold(
        body: Background(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        const _BackButton(),
        const _Title(),
        const SizedBox(height: 50),
        _AnimatedButton(
            animation: levelSelectorProvider.lowAnimation,
            selector: (_, provider) => provider.isNavigatingLow,
            text: texts.lowLevel,
            onTap: (_) => levelSelectorProvider.selectLow()),
        const SizedBox(height: 10),
        _AnimatedButton(
            animation: levelSelectorProvider.mediumAnimation,
            selector: (_, provider) => provider.isNavigatingMedium,
            text: texts.mediumLevel,
            onTap: (_) => levelSelectorProvider.selectMedium()),
        const SizedBox(height: 10),
        _AnimatedButton(
            animation: levelSelectorProvider.highAnimation,
            selector: (_, provider) => provider.isNavigatingHigh,
            text: texts.highLevel,
            onTap: (_) => levelSelectorProvider.selectHigh()),
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
                    onTap: () => levelSelectorProvider.goBack()
                  ));
            }));
  }
}

class _AnimatedButton extends StatelessWidget {
  final Animation<double> animation;
  final bool Function(BuildContext, LevelSelectorProvider) selector;
  final void Function(BuildContext) onTap;
  final String text;

  const _AnimatedButton({
    Key? key,
    required this.animation,
    required this.selector,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      builder: ((_, value, __) => CustomButton(text: text, color: customColors.buttonColor!, opacity: 0, isLoading: value, onTap: () => onTap(context)))));
            }));
  }
}
