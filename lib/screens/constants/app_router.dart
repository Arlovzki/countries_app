import 'package:countries_app/screens/detail_screen/detail_screen.dart';
import 'package:countries_app/screens/home_screen/home_screen.dart';
import 'package:countries_app/screens/mapscreen/map_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String homeScreen = '/homeScreen';
  static const String detailScreen = '/detailScreen';
  static const String mapScreen = '/mapScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return FadeTransition(opacity: animation1, child: HomeScreen());
          },
        );
      case detailScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return FadeTransition(
                opacity: animation1,
                child: DetailScreen(
                  map: settings.arguments,
                ));
          },
        );
      case mapScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return FadeTransition(
                opacity: animation1,
                child: MapScreen(
                  country: settings.arguments,
                ));
          },
        );
      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return FadeTransition(
              opacity: animation1,
              child: Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
          },
        );
    }
  }
}
