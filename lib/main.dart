import 'package:flutter/material.dart';
import 'package:BitTrans/pages/home.dart';
import 'package:BitTrans/pages/onBoarding.dart';
import 'package:BitTrans/prefrences.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BusStopUserPrefrences.init();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;

  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: showHome? Home() : OnboardingPage1(),
    );
  }
}
