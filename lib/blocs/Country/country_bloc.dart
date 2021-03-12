import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:countries_app/models/country/country.dart';
import 'package:countries_app/repository/getCountry.dart';
import 'package:meta/meta.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial());

  @override
  Stream<CountryState> mapEventToState(
    CountryEvent event,
  ) async* {
    yield CountryLoading();

    if (event is CountryGetEvent) {
      List<Country> countries = await getCountry(event.searchType,
          searchText: event.searchText, isMulti: event.isMulti);

      yield CountrySuccess(countries);
    }
  }
}
