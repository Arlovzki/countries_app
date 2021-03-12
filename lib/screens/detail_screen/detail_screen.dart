import 'package:cached_network_image/cached_network_image.dart';
import 'package:countries_app/models/country/country.dart';
import 'package:countries_app/repository/api_provider.dart';
import 'package:countries_app/repository/getCountry.dart';
import 'package:countries_app/screens/constants/app_router.dart';
import 'package:countries_app/screens/constants/styles.dart';
import 'package:countries_app/screens/constants/widgets/shake_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DetailScreen extends StatefulWidget {
  final Map map;

  const DetailScreen({Key key, this.map}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<Country> borderCountries = [];
  bool isLoading = true;

  Widget _buildAltSpellings(List<String> altSpellings) {
    String spellings = "";

    altSpellings.forEach((element) {
      if (spellings.isNotEmpty) {
        spellings = '$spellings, "$element"';
      } else {
        spellings = '"$element"';
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        '($spellings)',
        textAlign: TextAlign.center,
        style: text.copyWith(fontStyle: FontStyle.italic),
      ),
    );
  }

  void getBorderCountry(String searchText) async {
    var results;

    try {
      results = await getCountry(SearchType.searchByCode,
          searchText: searchText, isMulti: true);
    } on Exception {
      borderCountries = results;
    }
    if (mounted) {
      setState(() {
        borderCountries = results;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Country country = widget.map["country"];

    var countryJson = country.translations.toJson();
    List<String> translations = [];
    List<String> translationkeys = [];
    String borderParams = "";

    countryJson.values.forEach((element) {
      translations.add(element);
    });
    countryJson.keys.forEach((element) {
      translationkeys.add(element);
    });

    country.borders.forEach((element) {
      borderParams = "$borderParams$element;";
    });

    getBorderCountry(borderParams);

    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          IconButton(
              icon: Icon(Icons.home_outlined),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRouter.homeScreen, (route) => false);
              })
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ShakeTransition(
                  duration: Duration(milliseconds: 1100),
                  axis: Axis.vertical,
                  child: Container(
                    child: Hero(
                      tag: widget.map["fromHome"]
                          ? country.alpha2Code
                          : country.alpha3Code,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        imageUrl: imageUrl +
                            country.alpha2Code.toLowerCase() +
                            '.png',
                      ),
                    ),
                  ),
                ),
                ShakeTransition(
                  child: Text(
                    country.name,
                    textAlign: TextAlign.center,
                    style: text.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ShakeTransition(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Native name: ",
                          style: text.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: country.nativeName,
                          style: text.copyWith(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ShakeTransition(
                    child: _buildAltSpellings(country.altSpellings)),
                SizedBox(height: 10),
                ShakeTransition(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Domain",
                              style: text.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              country.topLevelDomain.first,
                              style: text.copyWith(
                                  fontSize: 14, color: Colors.blueAccent),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Alpha2Code",
                              style: text.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              country.alpha2Code,
                              style: text.copyWith(
                                  fontSize: 14, color: Colors.blueAccent),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Alpha3Code",
                              style: text.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              country.alpha3Code,
                              style: text.copyWith(
                                  fontSize: 14, color: Colors.blueAccent),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Calling Codes",
                              style: text.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "+${country.callingCodes.first}",
                              style: text.copyWith(
                                  fontSize: 14, color: Colors.blueAccent),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ShakeTransition(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 10, 10, 20),
                          child: Text(
                            "Country Details",
                            style: text.copyWith(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: Colors.black,
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                _buildInfoTile(
                    icon: Icon(Icons.home_work_outlined),
                    content: country.capital,
                    title: "Capital"),
                _buildInfoTile(
                    icon: Icon(Icons.map_outlined),
                    content: country.region,
                    title: "Region"),
                _buildInfoTile(
                    icon: Icon(Icons.map_rounded),
                    content: country.subregion,
                    title: "Sub-Region"),
                widget.map["country"].latlng.length > 0
                    ? _buildInfoTile(
                        icon: Icon(Icons.location_pin),
                        content:
                            "(${widget.map["country"].latlng.first}, ${widget.map["country"].latlng.last})",
                        title: "Latitude/Longitude",
                        forLatitude: true,
                        country: widget.map["country"])
                    : SizedBox.shrink(),
                _buildInfoTile(
                    icon: Icon(Icons.nature_people_rounded),
                    content: country.demonym,
                    title: "Demonym"),
                _buildInfoTile(
                    icon: Icon(Icons.run_circle_outlined),
                    content: country.cioc,
                    title: "Country IOC"),
                _buildInfoTile(
                    icon: Icon(Icons.format_list_numbered_outlined),
                    content: country.numericCode,
                    title: "Numeric code"),
                _buildInfoTile(
                    icon: Icon(Icons.location_city_outlined),
                    content: country.area,
                    title: "Area"),
                _buildInfoTile(
                    icon: Icon(Icons.people_outline_outlined),
                    content: country.population,
                    title: "Population"),
                _buildInfoTile(
                    icon: Icon(Icons.money_rounded),
                    content: country.numericCode,
                    title: "Gini"),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock),
                        SizedBox(width: 5),
                        Text(
                          "Timezones",
                          style: text.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: country.timezones.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.only(top: 25),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${country.timezones[index]}",
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.lock_clock),
                        SizedBox(width: 5),
                        Text(
                          "Currencies",
                          style: text.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 160,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: country.currencies.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 160,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.yellow[800],
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${country.currencies[index].symbol ?? "X"}",
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            Text(
                              country.currencies[index].code,
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                country.currencies[index].name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: text.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.language_outlined),
                        SizedBox(width: 5),
                        Text(
                          "Languages",
                          style: text.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: country.languages.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.fromLTRB(5, 25, 5, 0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${country.languages[index].iso639_1}",
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            Text(
                              country.languages[index].name,
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              country.languages[index].nativeName,
                              textAlign: TextAlign.center,
                              style: text.copyWith(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //Translations
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Icon(Icons.translate_outlined),
                        SizedBox(width: 5),
                        Text(
                          "Translations",
                          style: text.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: translations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange[600],
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.fromLTRB(5, 30, 5, 0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                translationkeys[index],
                                textAlign: TextAlign.center,
                                style: text.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35),
                              ),
                              Text(
                                translations[index],
                                textAlign: TextAlign.center,
                                style: text.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(width: 5),
                        Text(
                          "Border Countries",
                          style: text.copyWith(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: !isLoading
                ? Container(
                    height: 150,
                    child: borderCountries.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: borderCountries.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRouter.detailScreen,
                                      arguments: {
                                        "country": borderCountries[index],
                                        "fromHome": true,
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Container(
                                        child: Hero(
                                          tag:
                                              borderCountries[index].alpha3Code,
                                          child: CachedNetworkImage(
                                            height: 100,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            imageUrl: imageUrl +
                                                borderCountries[index]
                                                    .alpha2Code
                                                    .toLowerCase() +
                                                '.png',
                                          ),
                                        ),
                                      )),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 100,
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  Text("Can't retrieve the country"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Try Again?"),
                                      IconButton(
                                          icon: Icon(Icons.replay),
                                          onPressed: () {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            getBorderCountry(borderParams);
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                  )
                : Container(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    dynamic content,
    Icon icon,
    String title,
    bool forLatitude = false,
    Country country,
  }) {
    return ShakeTransition(
      child: InkWell(
        onTap: () {
          if (forLatitude) {
            Navigator.pushNamed(context, AppRouter.mapScreen,
                arguments: country);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  icon,
                  SizedBox(width: 10),
                  Text(
                    "$title: ",
                    style: text.copyWith(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text("$content", overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            forLatitude
                ? Text(
                    "Click to see the location",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.blue),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 5)
          ],
        ),
      ),
    );
  }
}
