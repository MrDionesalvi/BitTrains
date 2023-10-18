import 'package:flutter/material.dart';
import 'package:moj_lpp/pages/home.dart';
import 'package:moj_lpp/prefrences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BusStopUserPrefrences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
