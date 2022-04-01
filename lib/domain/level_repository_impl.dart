import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:wordly/data/collections/level_data.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/domain/level_repository.dart';

class LevelRepositoryImpl implements LevelRepository {
  late LevelData _levelData;
  bool _isLevelMode = false;

  @override
  bool get isLevelMode => _isLevelMode;

  @override
  set levelMode(final bool value) => _isLevelMode = value;

  @override
  LevelData get levelData => _levelData;

  @override
  Future<void> initLevelData(DictionaryLanguages language) async {
    final result = await GetIt.I<Isar>().levelDatas.get(language.index);
    _levelData = result ?? LevelData.init(language.index);
  }

  @override
  Future<void> saveLevelData({
    required final int level,
    required final String secretWord,
  }) async {
    final data = LevelData()
      ..id = _levelData.id
      ..lastLevel = level
      ..secretWord = secretWord;

    await GetIt.I<Isar>().writeTxn((isar) async {
      _levelData = data;
      await isar.levelDatas.put(_levelData);
    });
  }
}
