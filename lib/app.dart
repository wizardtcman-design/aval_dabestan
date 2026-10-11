import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'screens/games/dragdrop_game_screen.dart';
import 'screens/games/find_game_screen.dart';
import 'screens/games/memory_game_screen.dart';
import 'screens/games/match_game_screen.dart';
import 'screens/letters/letter_detail_screen.dart';
import 'screens/main_shell.dart';
import 'screens/numbers/numbers_home_screen.dart';
import 'screens/settings/settings_screen.dart';

/// ریشه اپلیکیشن — فارسی و راست‌به‌چپ
class KelasAvalApp extends StatelessWidget {
  const KelasAvalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'آموزش کلاس اول',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [Locale('fa', 'IR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: _onGenerateRoute,
      home: const MainShell(),
    );
  }

  static Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final segments = uri.pathSegments;

    // /letter/{index}
    if (segments.length == 2 && segments[0] == 'letter') {
      final index = int.tryParse(segments[1]);
      if (index != null) {
        return MaterialPageRoute(
          builder: (_) => LetterDetailScreen(letterIndex: index),
        );
      }
    }

    // /numbers
    if (segments.isNotEmpty && segments[0] == 'numbers') {
      return MaterialPageRoute(builder: (_) => const NumbersHomeScreen());
    }

    // /game/{type}?scope=letters&item=3
    if (segments.length == 2 && segments[0] == 'game') {
      final scope = uri.queryParameters['scope'] ?? 'letters';
      final item = int.tryParse(uri.queryParameters['item'] ?? '');
      switch (segments[1]) {
        case 'find':
          return MaterialPageRoute(
            builder: (_) =>
                FindGameScreen(scope: scope, fixedItem: item),
          );
        case 'match':
          return MaterialPageRoute(
            builder: (_) =>
                MatchGameScreen(scope: scope, fixedItem: item),
          );
        case 'memory':
          return MaterialPageRoute(
            builder: (_) =>
                MemoryGameScreen(scope: scope, fixedItem: item),
          );
        case 'dragdrop':
          return MaterialPageRoute(
            builder: (_) =>
                DragDropGameScreen(scope: scope, fixedItem: item),
          );
      }
    }

    // /settings
    if (segments.isNotEmpty && segments[0] == 'settings') {
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    }

    return null;
  }
}
