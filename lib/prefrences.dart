import 'dart:convert';
import 'package:moj_lpp/stops.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusStopUserPrefrences {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    print("Hello!");
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> set_home(Stop _stop) async {
    print(jsonEncode(_stop));
    await preferences?.setString("home", jsonEncode(_stop.toJson()));
  }

  static Future<void> set_school(Stop _stop) async {
    print(jsonEncode(_stop));

    print(preferences == null);
    await preferences?.setString("school", jsonEncode(_stop.toJson()));
  }

  static Future<void> set_line(String _line) async {
    await preferences?.setString("line", _line);
  }

  static Stop get_home() {
    if (preferences?.getString("home") != null) {
      return Stop.fromJson(
          jsonDecode((preferences?.getString("home")).toString()));
    } else {
      print("Is null");
      return Stops.all_stops.first;
    }
  }

  static Stop get_school() {
    if (preferences?.getString("school") != null) {
      return Stop.fromJson(
          jsonDecode((preferences?.getString("school")).toString()));
    } else {
      print("Is null");
      return Stops.all_stops.last;
    }
  }

  static String get_line() {
    if (preferences?.getString("line") != null) {
      return (preferences?.getString("line")).toString();
    } else {
      print("Is null");
      return "18";
    }
  }

  static Future<void> set_custom_label_home(String _label) async {
    await preferences?.setString("home_label", _label);
  }

  static Future<void> set_custom_label_school(String _label) async {
    print(preferences == null);
    await preferences?.setString("school_label", _label);
  }

  static String get_custom_label_school() {
    if ((preferences?.getString("school_label")).toString().isNotEmpty &&
        preferences?.getString("school_label") != null) {
      return (preferences?.getString("school_label")).toString();
    } else {
      print("Is null");
      return "school";
    }
  }

  static String get_custom_label_home() {
    if ((preferences?.getString("home_label")).toString().isNotEmpty &&
        preferences?.getString("home_label") != null) {
      return (preferences?.getString("home_label")).toString();
    } else {
      print("Is null");
      return "home";
    }
  }
}
