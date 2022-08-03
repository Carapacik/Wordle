import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wordly/data/models.dart';
import 'package:wordly/domain/save_settings_service.dart';

part 'locale_bloc.freezed.dart';
part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc({
    required this.settingsService,
    required LocaleEnum locale,
  }) : super(LocaleState.changeLocale(locale)) {
    on<_LocaleChangedEvent>(_onLocaleChanged);
  }

  final SaveSettingsService settingsService;

  Future<void> _onLocaleChanged(
    _LocaleChangedEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await settingsService.saveLocale(event.locale);
    emit(LocaleState.changeLocale(event.locale));
  }
}
