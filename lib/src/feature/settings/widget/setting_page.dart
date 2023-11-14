import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/utils/extensions/extensions.dart';
import 'package:wordly/src/feature/app/widget/dictionary_scope.dart';
import 'package:wordly/src/feature/app/widget/locale_scope.dart';
import 'package:wordly/src/feature/app/widget/theme_scope.dart';
import 'package:wordly/src/feature/components/widget/constraint_screen.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/settings/model/change_color_result.dart';
import 'package:wordly/src/feature/settings/widget/change_color_page.dart';
import 'package:wordly/src/feature/settings/widget/list_item_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.r.settings)),
      body: ConstraintScreen(
        child: Column(
          children: [
            ListItemSelector<Locale>(
              title: context.r.appDictionary,
              currentValue: (
                DictionaryScope.of(context).dictionary,
                _localeName(DictionaryScope.of(context).dictionary)
              ),
              items: [(const Locale('ru'), context.r.ru), (const Locale('en'), context.r.en)],
              onChange: (d) {
                DictionaryScope.of(context).setDictionary(d);
                context.read<GameBloc>().add(GameEvent.changeDictionary(d));
              },
            ),
            ListItemSelector<Locale>(
              title: context.r.appLanguage,
              currentValue: (LocaleScope.of(context).locale, _localeName(LocaleScope.of(context).locale)),
              items: [(const Locale('ru'), context.r.ru), (const Locale('en'), context.r.en)],
              onChange: (l) => LocaleScope.of(context).setLocale(l),
            ),
            ListItemSelector<ThemeMode>(
              title: context.r.themeMode,
              currentValue: (ThemeScope.of(context).theme.mode, _themeName(ThemeScope.of(context).theme.mode)),
              items: [
                (ThemeMode.system, context.r.themeSystem),
                (ThemeMode.dark, context.r.themeDark),
                (ThemeMode.light, context.r.themeLight),
              ],
              onChange: (mode) {
                final themeScope = ThemeScope.of(context, listen: false);
                final previousTheme = themeScope.theme;
                themeScope.setTheme(
                  previousTheme.copyWith(themeMode: mode),
                );
              },
            ),
            MergeSemantics(
              child: ListTileTheme.merge(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(context.r.colorMode, style: context.theme.bl),
                  trailing: Text(ThemeScope.of(context).theme.colorMode.localized(context), style: context.theme.bl),
                  onTap: () async {
                    final themeScope = ThemeScope.of(context, listen: false);
                    final previousTheme = themeScope.theme;
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute<ChangeColorResult>(
                        builder: (context) => ChangeColorPage(
                          previousResult: ChangeColorResult(
                            colorMode: previousTheme.colorMode,
                            otherColors: previousTheme.otherColors,
                          ),
                        ),
                      ),
                    );
                    if (result == null) {
                      return;
                    }
                    themeScope.setTheme(
                      previousTheme.copyWith(
                        colorMode: result.colorMode,
                        otherColors: result.otherColors,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _localeName(Locale locale) {
    final locales = {
      const Locale('en'): context.r.en,
      const Locale('ru'): context.r.ru,
    };
    return locales[locale] ?? context.r.en;
  }

  String _themeName(ThemeMode mode) {
    final themeModes = {
      ThemeMode.system: context.r.themeSystem,
      ThemeMode.dark: context.r.themeDark,
      ThemeMode.light: context.r.themeLight,
    };
    return themeModes[mode] ?? context.r.themeSystem;
  }
}
