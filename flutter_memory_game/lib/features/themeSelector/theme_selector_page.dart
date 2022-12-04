import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';

class ThemeSelectorPage extends StatelessWidget {
  final Object? arguments;

  const ThemeSelectorPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeSelectorProvider(),
      child: const ThemeSelectorWidget(),
    );
  }
}

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeSelectorProvider = Provider.of<ThemeSelectorProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;

    return Scaffold(
        body: Background(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
        Expanded(
            child: Center(
                child: AnimatedBuilder(
          animation: themeSelectorProvider.labelAnimation,
          builder: (BuildContext _, Widget? __) {
            return Opacity(opacity: themeSelectorProvider.labelAnimation.value, child: TitleText(text: texts.themeSelectorTitle));
          },
        ))),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _CardWidget(
                      text: texts.themeSelectorDc,
                      imageName: 'assets/images/dc_logo.jpg',
                      buttonAligment: HorizontalAligment.right,
                      rectCorner: RectCorner.bottomRight,
                      animation: themeSelectorProvider.dcAnimation,
                      selector: (_, provider) => provider.isNavigatingDc,
                      onTap: (_) => themeSelectorProvider.selectDc()),
              const SizedBox(width: 20),
              _CardWidget(
                  text: texts.themeSelectorMarvel,
                  imageName: 'assets/images/marvel_logo.jpg',
                  buttonAligment: HorizontalAligment.left,
                  rectCorner: RectCorner.bottomLeft,
                  animation: themeSelectorProvider.marvelAnimation,
                  selector: (_, provider) => provider.isNavigatingMarvel,
                  onTap: (_) => themeSelectorProvider.selectMarvel()),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _CardWidget(
                  text: texts.themeSelectorSimpsons,
                  imageName: 'assets/images/simpsons_logo.jpg',
                  buttonAligment: HorizontalAligment.right,
                  rectCorner: RectCorner.topRight,
                  animation: themeSelectorProvider.simpsonsAnimation,
                  selector: (_, provider) => provider.isNavigatingSimpsons,
                  onTap: (_) => themeSelectorProvider.selectSimpsons()),
              const SizedBox(width: 20),
              _CardWidget(
                  text: texts.themeSelectorStarWars,
                  imageName: 'assets/images/star_wars_logo.jpg',
                  buttonAligment: HorizontalAligment.left,
                  rectCorner: RectCorner.topLeft,
                  animation: themeSelectorProvider.starWarsAnimation,
                  selector: (_, provider) => provider.isNavigatingStarWars,
                  onTap: (_) => themeSelectorProvider.selectStarWars()),
            ],
          ),
        ),
        const SizedBox(height: 50)
      ]),
    ));
  }
}

class _CardWidget extends StatelessWidget {
  final Animation<double> animation;
  final bool Function(BuildContext, ThemeSelectorProvider) selector;
  final String text;
  final String imageName;
  final HorizontalAligment buttonAligment;
  final RectCorner rectCorner;
  final Function(BuildContext) onTap;

  const _CardWidget(
      {Key? key,
      required this.text,
      required this.animation,
      required this.imageName,
      required this.buttonAligment,
      required this.rectCorner,
      required this.selector, 
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: AnimatedBuilder(
      animation: animation,
      builder: (BuildContext _, Widget? __) {
        return Opacity(
            opacity: animation.value,
            child: Selector<ThemeSelectorProvider, bool>(
              builder: ((_, value, __) => 
              ThemeButton(
                imageName: imageName,
                buttonAligment: buttonAligment,
                text: text,
                isLoading: value,
                rectCorner: rectCorner,
                onTap: () => onTap(context))), 
              selector: selector)
            );
      },
    ));
  }
}
