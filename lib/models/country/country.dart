import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  final String name;
  final List<String> topLevelDomain;
  final String alpha2Code;
  final String alpha3Code;
  final List<String> callingCodes;
  final String capital;
  final List<String> altSpellings;
  final String region;
  final String subregion;
  final int population;
  final List<double> latlng;
  final String demonym;
  final double area;
  final double gini;
  final List<String> timezones;
  final List<String> borders;
  final String nativeName;
  final String numericCode;
  final List<Currency> currencies;
  final List<Language> languages;
  final Translation translations;
  final String flag;
  final List<RegionalBloc> regionalBlocs;
  final String cioc;

  Country(
      {this.name,
      this.topLevelDomain,
      this.alpha2Code,
      this.alpha3Code,
      this.callingCodes,
      this.capital,
      this.altSpellings,
      this.region,
      this.subregion,
      this.population,
      this.latlng,
      this.demonym,
      this.area,
      this.gini,
      this.timezones,
      this.borders,
      this.nativeName,
      this.numericCode,
      this.currencies,
      this.languages,
      this.translations,
      this.flag,
      this.regionalBlocs,
      this.cioc});

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}

@JsonSerializable()
class Currency {
  final String code;
  final String name;
  final String symbol;

  Currency({this.code, this.name, this.symbol});
  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable()
class Language {
  final String iso639_1;
  final String iso639_2;
  final String name;
  final String nativeName;

  Language({this.iso639_1, this.iso639_2, this.name, this.nativeName});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable()
class Translation {
  final String de; // Germany
  final String es; // Spain
  final String fr; // France
  final String ja; //Japan
  final String it; // Italy
  final String br; //Brazil
  final String pt; //Portugal
  final String nl; //Netherlands
  final String hr; //Croatia
  final String fa; //Afghanistan

  Translation(
      {this.de,
      this.es,
      this.fr,
      this.ja,
      this.it,
      this.br,
      this.pt,
      this.nl,
      this.hr,
      this.fa});
  factory Translation.fromJson(Map<String, dynamic> json) =>
      _$TranslationFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationToJson(this);
}

@JsonSerializable()
class RegionalBloc {
  final String acronym;
  final String name;
  final List<String> otherAcronyms;
  final List<String> otherNames;

  RegionalBloc({this.acronym, this.name, this.otherAcronyms, this.otherNames});
  factory RegionalBloc.fromJson(Map<String, dynamic> json) =>
      _$RegionalBlocFromJson(json);
  Map<String, dynamic> toJson() => _$RegionalBlocToJson(this);
}
