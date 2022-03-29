import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/main/main_cubit.dart';
import 'package:wordly/bloc/settings/settings_cubit.dart';
import 'package:wordly/data/models/dictionary_languages.dart';
import 'package:wordly/data/models/flushbar_types.dart';
import 'package:wordly/ui/pages/main/widgets/word_grid.dart';
import 'package:wordly/ui/pages/statistic/statistic_page.dart';
import 'package:wordly/ui/widgets/widgets.dart';
import 'package:wordly/utils/utils.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(
        title: R.stringsOf(context).wordle.toUpperCase(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const StatisticPage(),
                ),
              );
            },
            icon: const Icon(Icons.leaderboard),
          ),
        ],
      ),
      body: Responsive(
        mobile: BlocListener<MainCubit, MainState>(
          listener: (context, state) async {
            if (state is TopMessageState) {
              switch (state.type) {
                case FlushBarTypes.notFound:
                  showTopFlushBar(
                    context,
                    message: R.stringsOf(context).word_not_found,
                  );
                  break;
                case FlushBarTypes.notCorrectLength:
                  showTopFlushBar(
                    context,
                    message: R.stringsOf(context).word_too_short,
                  );
                  break;
              }
            } else if (state is WinGameState) {
              await showWinLoseDialog(context);
            } else if (state is LoseGameState) {
              await showWinLoseDialog(
                context,
                isWin: false,
              );
            }
          },
          child: BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.dictionaryLanguage != current.dictionaryLanguage,
            builder: (_, state) {
              return Column(
                key: UniqueKey(),
                children: [
                  const SizedBox(height: 16),
                  const WordsGrid(),
                  const Spacer(),
                  state.dictionaryLanguage.keyboard,
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
