import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';

import 'package:http/http.dart';

Future<Map<String, dynamic>> get_bus(String url, String line) async {
  try {
    final response = await get(Uri.parse(url)).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Create a result list to store the filtered data.
      Map<String, dynamic>? resultList;

      if (jsonData == null) {
        return {
          'line_name': " ",
          'time': "Error",
          'minutes': "No buses found!",
          "line": " ",
          'key': " ",
        };
      }
      print("Cerco la linea {$line} nella fermata {$url}");
      for (var item in jsonData) {
        //print(item['line']); 
        if (line == item['line'].toString()) {
          //print("Minutes: " + item["hour"].toString());
          String realtime = "🟡";
          if (item['realtime'].toString() == "true") {
            realtime = "🟢";
          }          resultList = {
            'line_name': item['line'],
            'time': item['hour'],
            'minutes': "In arrivo ${item['hour']}",
            'line': realtime
          };
          break;
        }
      }
      if (resultList != null) {
        return resultList;
      } else {
        throw Exception();
      }
    }
  } on TimeoutException catch (_) {
    return {
      'line_name': " ",
      'time': "Error",
      'minutes': "Connection timed out!",
      'key': " ",
      "line": " ",
    };
  } catch (error) {
    print(error);
    return {
      'line_name': " ",
      'time': "Error",
      'minutes': "An error occured!",
      'key': " ",
      "line": " ",
    };
  }

  return {
    'line_name': " ",
    'time': "Error",
    'minutes': "No buses found!",
    'key': " ",
    "line": " ",
  };
}

class Arrivals {
  List<BusArrival> arrivals = List.empty(growable: true);
  String line = "";
  String lineId = "";

  Arrivals(String _line, String _lineId) {
    line = _line;
    lineId = _lineId;
  }

  void add_arrival(BusArrival _arrival) {
    arrivals.add(_arrival);
  }

  String gen_time() {
    String ret = "";
    int i = 0;
    for (BusArrival arrival in arrivals) {
      i++;

      ret = ret + "  " + (i > 1 ? "*" : "") + arrival.minutes;

      if (i >= 2) {
        return ret;
      }
    }
    return ret;
  }
}

class BusArrival {
  String minutes = "";
  String time = "";

  BusArrival(String _minutes, String _time) {
    minutes = _minutes;
    time = _time;
  }
}

Future<List<Arrivals>> get_arrivals(String url) async {
  List<Arrivals> arrivals_list = List.empty(growable: true);

  try {
    final response = await get(Uri.parse(url)).timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Create a result list to store the filtered data.

      if (jsonData[0] == null) {
        return arrivals_list;
      }

      for (var item in jsonData) {
        Arrivals arrival = Arrivals("", "");
        for (var subItem in item) {
          arrival.line = subItem["name"].toString();
          arrival.lineId = subItem["key"].toString();
          arrival.add_arrival(BusArrival(
              subItem["minutes"].toString(), subItem["time"].toString()));
        }

        if (arrival.line != "") {
          arrivals_list.add(arrival);
        }
      }
    }
    return arrivals_list;
  } catch (_) {
    return arrivals_list;
  }
}
