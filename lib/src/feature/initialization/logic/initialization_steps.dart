import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordly/src/feature/app/data/dictionary_datasource.dart';
import 'package:wordly/src/feature/app/data/dictionary_repository.dart';
import 'package:wordly/src/feature/app/data/locale_datasource.dart';
import 'package:wordly/src/feature/app/data/locale_repository.dart';
import 'package:wordly/src/feature/app/data/theme_datasource.dart';
import 'package:wordly/src/feature/app/data/theme_repository.dart';
import 'package:wordly/src/feature/game/data/game_datasource.dart';
import 'package:wordly/src/feature/game/data/game_repository.dart';
import 'package:wordly/src/feature/initialization/model/dependencies.dart';
import 'package:wordly/src/feature/initialization/model/initialization_progress.dart';
import 'package:wordly/src/feature/level/data/level_datasource.dart';
import 'package:wordly/src/feature/level/data/level_repository.dart';
import 'package:wordly/src/feature/statistic/data/statistics_datasource.dart';
import 'package:wordly/src/feature/statistic/data/statistics_repository.dart';

/// A function which represents a single initialization step.
typedef StepAction = FutureOr<void>? Function(InitializationProgress progress);

/// The initialization steps, which are executed in the order they are defined.
///
/// The [Dependencies] object is passed to each step, which allows the step to
/// set the dependency, and the next step to use it.
mixin InitializationSteps {
  /// The initialization steps,
  /// which are executed in the order they are defined.
  final initializationSteps = <String, StepAction>{
    'Shared Preferences': (progress) async {
      final sharedPreferences = await SharedPreferences.getInstance();
      progress.dependencies.sharedPreferences = sharedPreferences;
    },
    'Theme Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final themeDataSource = ThemeDataSourceImpl(sharedPreferences);
      progress.dependencies.themeRepository = ThemeRepositoryImpl(
        themeDataSource,
      );
    },
    'Locale Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final localeDataSource = LocaleDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.localeRepository = LocaleRepositoryImpl(
        localeDataSource,
      );
    },
    'Dictionary Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final dictionaryDataSource = DictionaryDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.dictionaryRepository = DictionaryRepositoryImpl(
        dictionaryDataSource,
      );
    },
    'Statistics Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final statisticsDataSource = StatisticsDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.statisticsRepository = StatisticsRepositoryImpl(
        statisticsDataSource,
      );
    },
    'Level Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final lvlDataSource = LevelDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      progress.dependencies.levelRepository = LevelRepositoryImpl(
        lvlDataSource,
      );
    },
    'Game Repository': (progress) async {
      final sharedPreferences = progress.dependencies.sharedPreferences;
      final gameDataSource = GameDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );
      final gameRepository = GameRepository(gameDataSource: gameDataSource);
      await gameRepository.init();
      progress.dependencies.gameRepository = gameRepository;
    },
  };
}
