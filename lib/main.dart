import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/Country/country_bloc.dart';
import 'screens/constants/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CountryBloc>(
          create: (context) => CountryBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.homeScreen,
      ),
    );
  }
}
