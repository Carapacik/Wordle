part of 'locale_bloc.dart';

@freezed
class LocaleEvent with _$LocaleEvent {
  const LocaleEvent._();

  const factory LocaleEvent.localeChanged({required String locale}) =
      _LocaleChangedEvent;
}
