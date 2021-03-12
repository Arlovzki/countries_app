part of 'country_bloc.dart';

@immutable
abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountrySuccess extends CountryState {
  final List<Country> countries;

  CountrySuccess(this.countries);
}
