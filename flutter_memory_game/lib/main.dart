import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vsync_provider/vsync_provider.dart';

import 'router/routes.dart';
import 'themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
     MultiProvider(
        providers: const [VsyncProvider(isSingleTicker: false)],
        child: MaterialApp(
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
