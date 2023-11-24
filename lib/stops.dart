class Stop {
  String name = "";
  String value = "";

  Stop(String _name, String _value) {
    name = _name;
    value = _value;
  }

  ({String name, bool is_to_center}) gen_name() {
    return (name: name + " (" + value + ")", is_to_center: false);
  }

  bool to_center() {
    if (int.parse(value) % 2 != 0) {
      return true;
    } else {
      return false;
    }
  }

  Stop.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value,
      };
}

class Stops {
  static Stop find_stop_by_id(String _id) {
    return all_stops.where((element) => element.value == _id).single;
  }

  static List<String> lines = [
    "9",
    "3"
  ];

  static List<Stop> all_stops = [
    Stop("Martinetto", "3011"),
    Stop("Ospedale Maria Vittoria", "3013"),
    Stop("Fabrizi", "456"),
    Stop("Bernini M1", "597"),
    Stop("Università", "185") // LASCIARE COSI TODO: RISOLVERE
  ];
}
