part of 'country_bloc.dart';

@immutable
abstract class CountryEvent {}

class CountryGetEvent extends CountryEvent {
  final SearchType searchType;
  final bool isMulti;
  final String searchText;

  CountryGetEvent(
      {this.searchType = SearchType.searchAll,
      this.isMulti = false,
      this.searchText = ""});
}
