import 'package:cached_network_image/cached_network_image.dart';
import 'package:countries_app/models/country/country.dart';
import 'package:countries_app/repository/api_provider.dart';
import 'package:countries_app/screens/constants/app_router.dart';
import 'package:countries_app/screens/constants/styles.dart';
import 'package:flutter/material.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    Key key,
    @required this.country,
  }) : super(key: key);

  final Country country;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.detailScreen, arguments: {
          "country": country,
          "fromHome": true,
        });
      },
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Hero(
                        tag: country.alpha2Code,
                        child: CachedNetworkImage(
                          width: 80,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          imageUrl: imageUrl +
                              country.alpha2Code.toLowerCase() +
                              '.png',
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: country.name,
                              style: text.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: ", ",
                                  style: text.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${country.alpha2Code}",
                                  style: text.copyWith(
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios_outlined))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
