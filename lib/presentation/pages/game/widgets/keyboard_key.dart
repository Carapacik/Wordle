import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordly/bloc/game/game_bloc.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/resources/resources.dart';

class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    required this.keyboardKey,
    this.dictionary = DictionaryEnum.en,
    super.key,
  });

  final KeyboardKeys keyboardKey;
  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        width: keyboardKey.size(
          context,
          dictionary: dictionary,
        ),
        child: BlocBuilder<GameBloc, GameState>(
          buildWhen: (_, current) => current.isSubmit,
          builder: (context, state) => AspectRatio(
            aspectRatio: dictionary.aspectRatio,
            child: Material(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(6),
              color: _bgColorByState(state, context),
              child: InkWell(
                onTap: () {
                  context.read<GameBloc>().add(
                        GameEvent.letterPressed(keyboardKey),
                      );
                },
                borderRadius: BorderRadius.circular(6),
                child: Center(
                  child: Text(
                    keyboardKey.fromDictionary(dictionary)?.toUpperCase() ?? '',
                    style: context.theme.ll.copyWith(
                      color: _txtColorByState(state, context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Color _bgColorByState(GameState state, BuildContext context) {
    final color = state.whenOrNull(
          wordSubmit: (_, keyboard) {
            if (keyboard.containsKey(keyboardKey)) {
              return keyboard[keyboardKey]?.keyboardItemColor(context);
            }
            return null;
          },
        ) ??
        context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        );
    return color;
  }

  Color _txtColorByState(GameState state, BuildContext context) {
    final color = state.whenOrNull(
          wordSubmit: (_, keyboard) {
            if (keyboard.containsKey(keyboardKey)) {
              return keyboard[keyboardKey] != LetterStatus.unknown
                  ? Colors.white
                  : null;
            }
            return context.dynamicColor(
              light: AppColors.dark,
              dark: AppColors.light,
            );
          },
        ) ??
        context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        );
    return color;
  }
}

class EnterKeyboardKey extends StatelessWidget {
  const EnterKeyboardKey({this.dictionary = DictionaryEnum.en, super.key});

  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) {
    final size = KeyboardKeys.enter.size(context, dictionary: dictionary);
    return Container(
      margin: const EdgeInsets.only(right: 2),
      height: size,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(6),
        color: context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        ),
        child: InkWell(
          onTap: () {
            context.read<GameBloc>().add(const GameEvent.enterPressed());
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              KeyboardKeys.enter.fromDictionary(dictionary)!.toUpperCase(),
              style: context.theme.ll,
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteKeyboardKey extends StatelessWidget {
  const DeleteKeyboardKey({this.dictionary = DictionaryEnum.en, super.key});

  final DictionaryEnum dictionary;

  @override
  Widget build(BuildContext context) {
    final size = KeyboardKeys.delete.size(context, dictionary: dictionary);
    return Container(
      margin: const EdgeInsets.only(left: 2),
      width: size,
      height: size,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(6),
        color: context.dynamicColor(
          light: AppColors.lightGrey,
          dark: AppColors.darkGrey,
        ),
        child: InkWell(
          onTap: () {
            context.read<GameBloc>().add(const GameEvent.deletePressed());
          },
          onLongPress: () {
            context.read<GameBloc>().add(const GameEvent.deleteLongPressed());
          },
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              color: context.dynamicColor(
                light: AppColors.dark,
                dark: AppColors.light,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
