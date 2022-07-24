import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wordly/app.dart';
import 'package:wordly/app/app.dart';
import 'package:wordly/app/service_locator.dart';
import 'package:wordly/bloc/dictionary/dictionary_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/bloc/locale/locale_bloc.dart';
import 'package:wordly/bloc/theme/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setPathUrlStrategy();
  await setupServiceLocators();

  final prefs = await SharedPreferences.getInstance();
  final dictionary = prefs.getInt('dictionary') ?? 0;
  // TODO get data from services
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<DictionaryBloc>(
          create: (_) => DictionaryBloc(dictionary),
        ),
        BlocProvider<LocaleBloc>(
          create: (_) => LocaleBloc(0),
        ),
        BlocProvider<GameBloc>(
          create: (_) => GameBloc(dictionary),
        ),
        BlocProvider<ThemeBloc>(
          create: (_) => ThemeBloc(ThemeData(), isHighContrast: false),
        ),
      ],
      child: const App(),
    ),
  );
}

