import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

import 'package:flutter_memory_game/services/services.dart';

import 'router/routes.dart';
import 'themes/themes.dart';

void main() {
  setup();
  runApp(const MyApp());
}

void setup() {
  GetIt.I.registerSingleton<NavigationServiceBase>(NavigationService());
  GetIt.I.registerSingleton<DialogServiceBase>(DialogService());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
     MultiProvider(
        providers: const [VsyncProvider(isSingleTicker: false)],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Memory Game',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: Routes.onGenerateRoute,
          //routes: Routes.getAppRoutes(),
          initialRoute: Routes.initialRoute,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
  }
}
