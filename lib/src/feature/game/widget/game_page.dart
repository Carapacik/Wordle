import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/src/core/extension/extensions.dart';
import 'package:wordly/src/feature/app/widget/dictionary_scope.dart';
import 'package:wordly/src/feature/components/widget/drawer.dart';
import 'package:wordly/src/feature/game/logic/game_bloc.dart';
import 'package:wordly/src/feature/game/model/game_mode.dart';
import 'package:wordly/src/feature/game/widget/game_result_dialog.dart';
import 'package:wordly/src/feature/game/widget/keyboard_by_language.dart';
import 'package:wordly/src/feature/game/widget/words_grid.dart';
import 'package:wordly/src/feature/statistic/widget/statistic_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<GameBloc>().state;
      if (state.isResultState) {
        unawaited(
          showGameResultDialog(
            context,
            state.secretWord,
            context.dependencies.gameRepository.currentDictionary(state.dictionary)[state.secretWord] ?? '',
            isWin: state.maybeMap(win: (_) => true, orElse: false),
            onTimerEnd: GameMode.daily == GameMode.daily ? () {} : null,
            mode: GameMode.daily,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) =>
          previous.gameCompleted != current.gameCompleted &&
          previous.dictionary == current.dictionary &&
          current.isResultState,
      listener: (context, state) {
        if (state.isResultState) {
          unawaited(
            showGameResultDialog(
              context,
              state.secretWord,
              context.dependencies.gameRepository.currentDictionary(state.dictionary)[state.secretWord] ?? '',
              isWin: state.maybeMap(win: (_) => true, orElse: false),
              onTimerEnd: GameMode.daily == GameMode.daily ? () {} : null,
              mode: GameMode.daily,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (true)
              IconButton(
                tooltip: context.r.view_statistic,
                icon: const Icon(Icons.leaderboard),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => StatisticPage(
                        dictionary: DictionaryScope.of(context, listen: false).dictionary,
                      ),
                    ),
                  );
                },
              )
            else
              IconButton(
                tooltip: context.r.view_levels,
                icon: const Icon(Icons.apps),
                onPressed: () {},
              ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: const GameBody(),
      ),
    );
  }
}

class GameBody extends StatelessWidget {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          Center(child: WordsGrid()),
          Center(child: KeyboardByLanguage()),
        ],
      ),
    );
  }
}
