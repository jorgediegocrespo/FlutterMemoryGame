import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/models/models.dart';
import 'package:flutter_memory_game/router/routes.dart';

class ThemeSelectorPage extends StatelessWidget {
  final Object? arguments;

  const ThemeSelectorPage({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeSelectorProvider(vsync: VsyncProvider.of(context)),
      child: ThemeSelectorWidget(arguments: arguments),
    );
  }
}

class ThemeSelectorWidget extends StatelessWidget {
  final Object? arguments;

  const ThemeSelectorWidget({Key? key, this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeSelectorProvider = Provider.of<ThemeSelectorProvider>(context, listen: false);
    final texts = AppLocalizations.of(context)!;
    final gameInfo = GameInfo();

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
                      updateNavigating: (x) => themeSelectorProvider.isNavigatingDc = x,
                      theme: Themes.dc,
                      gameInfo: gameInfo),
              const SizedBox(width: 20),
              _CardWidget(
                  text: texts.themeSelectorMarvel,
                  imageName: 'assets/images/marvel_logo.jpg',
                  buttonAligment: HorizontalAligment.left,
                  rectCorner: RectCorner.bottomLeft,
                  animation: themeSelectorProvider.marvelAnimation,
                  selector: (_, provider) => provider.isNavigatingMarvel,
                  updateNavigating: (x) => themeSelectorProvider.isNavigatingMarvel = x,
                  theme: Themes.marvel,
                  gameInfo: gameInfo),
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
                  updateNavigating: (x) => themeSelectorProvider.isNavigatingSimpsons = x,
                  theme: Themes.simpsons,
                  gameInfo: gameInfo),
              const SizedBox(width: 20),
              _CardWidget(
                  text: texts.themeSelectorStarWars,
                  imageName: 'assets/images/star_wars_logo.jpg',
                  buttonAligment: HorizontalAligment.left,
                  rectCorner: RectCorner.topLeft,
                  animation: themeSelectorProvider.starWarsAnimation,
                  selector: (_, provider) => provider.isNavigatingStarWars,
                  updateNavigating: (x) => themeSelectorProvider.isNavigatingStarWars = x,
                  theme: Themes.starWars,
                  gameInfo: gameInfo),
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
  final void Function(bool) updateNavigating;
  final bool Function(BuildContext, ThemeSelectorProvider) selector;
  final String text;
  final String imageName;
  final HorizontalAligment buttonAligment;
  final RectCorner rectCorner;
  final Themes theme;
  final GameInfo gameInfo;

  const _CardWidget(
      {Key? key,
      required this.text,
      required this.animation,
      required this.updateNavigating,
      required this.imageName,
      required this.buttonAligment,
      required this.rectCorner,
      required this.theme,
      required this.gameInfo, required this.selector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeSelectorProvider = Provider.of<ThemeSelectorProvider>(context, listen: false);

    return Expanded(
        child: AnimatedBuilder(
      animation: animation,
      builder: (BuildContext _, Widget? __) {
        return Opacity(
            opacity: animation.value,
            child: Selector<ThemeSelectorProvider, bool>(
              builder: ((_, value, __) => 
              CardButton(
                imageName: imageName,
                buttonAligment: buttonAligment,
                text: text,
                isLoading: value,
                rectCorner: rectCorner,
                onTap: () {
                  updateNavigating(true);
                  themeSelectorProvider.animationController.reverse().whenCompleteOrCancel(() async {
                    gameInfo.theme = theme;
                    Navigator.pushNamed(context, Routes.levelSelector, arguments: gameInfo).then((value) => themeSelectorProvider.animationController.forward());
                    updateNavigating(false);
                  });
                })), 
              selector: selector)
            );
      },
    ));
  }
}
