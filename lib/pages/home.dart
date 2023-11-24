import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import "package:flutter/material.dart";
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moj_lpp/dialog/loading_screen.dart';
import "package:flutter/services.dart";

import 'package:moj_lpp/fetch_bus.dart';
import 'package:moj_lpp/pages/settings.dart';
import 'package:moj_lpp/prefrences.dart';
import 'package:moj_lpp/stops.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String line = "";
  String line_name = "";
  String time = "";
  String minutes = "";
  String stop_name = "";
  String stop_value = "";
  String type = "";
  String line_preference = "18";
  bool show_all_buses = false;
  int selected_route = 0;
  List<Stop> stops = [Stops.all_stops.first, Stops.all_stops.last];
  Stop stop = Stops.all_stops.first;
  List<Arrivals> arrivals = List.empty(growable: true);

  String label_home = "Casa 🏡";
  String label_school = "Università 🏫";
  bool settings_opened = false;
  bool refresh_all_buses_on_navigate = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) async => await Refresh());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Refresh();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  bool is_refreshing = false;

  Future<void> Refresh() async {
    print(is_refreshing);
    if (settings_opened) {
      return;
    }
    print("Ricontrollo il tutto!\n");
    if (!is_refreshing) {
      print("Refresh");
      is_refreshing = true;
      if (selected_route <= 1) {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Center(child: CircularProgressIndicator());
        //     });
        LoadingScreen.instance().show(context: context);
        line_preference = BusStopUserPrefrences.get_line();
        stops[1] = BusStopUserPrefrences.get_school();
        stops[0] = BusStopUserPrefrences.get_home();

        final busData = await get_bus(
            'https://gpa.madbob.org/query.php?stop=${stops[selected_route].value}',
            line_preference);

        setState(() {
          line = busData["line"].toString();
          line_name = busData["line_name"].toString();
          minutes = busData["minutes"].toString();
          time = busData["time"].toString();
          stop_name = stops[selected_route].name;
          stop_value = stops[selected_route].value;

          label_home = BusStopUserPrefrences.get_custom_label_home();
          label_school = BusStopUserPrefrences.get_custom_label_school();
        });
        // Navigator.of(context).pop();
        LoadingScreen.instance().hide();
      }
      setState(() {
        label_home = BusStopUserPrefrences.get_custom_label_home();
        label_school = BusStopUserPrefrences.get_custom_label_school();

        if (selected_route == 2) {
          type = "Select stop";
        } else {
          type = selected_route == 0 ? "Direzione $label_school" : "Direzione $label_home";
        }
      });

      if (selected_route == 2) {
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Center(child: CircularProgressIndicator());
        //     });
        if (refresh_all_buses_on_navigate) {
          LoadingScreen.instance().show(context: context);
        }
        final _arrivals =
            await get_arrivals('https://gpa.madbob.org/query.php?stop=${stop.value}');
        setState(() {
          _arrivals.sort((a, b) {
            // Check if both Arrivals have at least one BusArrival
            if (a.arrivals.isNotEmpty && b.arrivals.isNotEmpty) {
              // Convert minutes to integers for comparison
              int minutesA = int.parse(a.arrivals[0].minutes);
              int minutesB = int.parse(b.arrivals[0].minutes);
              return minutesA.compareTo(minutesB);
            } else {
              // Handle cases where one or both Arrivals have no BusArrival
              return 0; // No change in order
            }
          });
          arrivals = _arrivals;
          label_home = BusStopUserPrefrences.get_custom_label_home();
          label_school = BusStopUserPrefrences.get_custom_label_school();
        });
        if (refresh_all_buses_on_navigate) {
          LoadingScreen.instance().hide();
        }
        refresh_all_buses_on_navigate = false;
        // Navigator.of(context).pop();
      }
      is_refreshing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: AppBar(
          title: Text(type,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                settings_opened = true;
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
                refresh_all_buses_on_navigate = true;
                settings_opened = false;
                await Refresh();
              },
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected_route,
          selectedItemColor: Colors.blue.shade400,
          selectedIconTheme: IconThemeData(color: Colors.blue.shade400),
          unselectedItemColor: Colors.blueGrey.shade700,
          unselectedIconTheme: IconThemeData(color: Colors.blueGrey.shade700),
          backgroundColor: Colors.blueGrey.shade900,
          onTap: (value) {
            print(value);
            setState(() {
              refresh_all_buses_on_navigate = value == 2 && selected_route != 2;
              selected_route = value;
              if (value <= 1) {
                show_all_buses = false;
              } else {
                if (value == 2) {
                  print("All buses!");
                  show_all_buses = true;
                }
              }
            });
            Refresh();
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.school),
                label: "$label_school",
                tooltip: "Direzione $label_school",
                backgroundColor: Colors.blueGrey.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: "$label_home",
                tooltip: "Direzione $label_home",
                backgroundColor: Colors.blueGrey.shade800),
            BottomNavigationBarItem(
                icon: const Icon(Icons.bus_alert),
                label: "Arriva alle ore",
                tooltip: "Arriva alle ore",
                backgroundColor: Colors.blueGrey.shade800),
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!show_all_buses) ...[
                  const Padding(padding: EdgeInsets.all(42)),
                  Text(
                    "Fermata: $stop_name ($stop_value) - Linea: $line_name",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      line_name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  */
                  Text(
                    line,
                    style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                  const Padding(padding: EdgeInsets.all(12)),
                  Text(
                    time,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    minutes,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: TextButton(
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Premi per aggiornare",
                            style: TextStyle(color: Colors.blueGrey.shade700),
                          ),
                        ),
                      ),
                      onPressed: () => {Refresh()},
                    ),
                  )
                ] else ...[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: DropdownSearch<Stop>(
                      items: Stops.all_stops,
                      selectedItem: stop,
                      itemAsString: (Stop s) => s.gen_name().name,
                      dropdownDecoratorProps: DropDownDecoratorProps(
                          baseStyle: TextStyle(color: Colors.white),
                          dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey.shade700,
                                      width: 5)))),
                      popupProps: PopupProps.modalBottomSheet(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) {
                            return SizedBox(
                              height: 60,
                              child: Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.gen_name().name,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16
                                            // Change the text color based on selection
                                            ),
                                      ),
                                      Padding(padding: EdgeInsets.all(6)),
                                      Visibility(
                                        visible: item.gen_name().is_to_center,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: Colors.amber.shade700,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Text("To Center"),
                                        ),
                                      )
                                    ]),
                              ),
                            );
                          },
                          searchFieldProps: TextFieldProps(
                            style: TextStyle(color: Colors.white),
                          ),
                          modalBottomSheetProps: ModalBottomSheetProps(
                            backgroundColor: Colors.blueGrey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          listViewProps: ListViewProps(),
                          searchDelay: Duration(milliseconds: 50)),
                      onChanged: (Stop? s) async {
                        if (s != null) {
                          stop = s;
                          LoadingScreen.instance().show(context: context);
                          await Refresh();
                          LoadingScreen.instance().hide();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Refresh();
                      },
                      color: Colors.white,
                      backgroundColor: Colors.blue.shade700,
                      displacement: 20,
                      semanticsLabel: "Refreshes selected bus station info",
                      child: ListView.builder(
                          itemCount: arrivals.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    context: context,
                                    backgroundColor: Colors.blueGrey.shade900,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          child: Column(children: [
                                        Padding(padding: EdgeInsets.all(20)),
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            arrivals[index].line,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          constraints:
                                              BoxConstraints(minWidth: 40),
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: Colors.amber.shade700,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Text(
                                            arrivals[index].lineId,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.blueGrey.shade900,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(20)),
                                        Text("Arriva alle: ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold)),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: arrivals[index]
                                                  .arrivals
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return ListTile(
                                                    title: Center(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${arrivals[index].arrivals[i].time.toString()}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          "(Arriva in ${arrivals[index].arrivals[i].minutes.toString()} minuti) ${arrivals[index].realTime == "true" ? "In tempo reale ✔" : "Programmato ❌"}",
                                                          style: TextStyle(
                                                              color:arrivals[index].realTime == "true" ? Colors.green : Colors.yellow,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10)),
                                                    ],
                                                  ),
                                                ));
                                              }),
                                        ),
                                      ]));
                                    })
                              },
                              child: ListTile(
                                leading: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.amber.shade700,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                    arrivals[index].lineId,
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade900,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                                title: Text(
                                  arrivals[index].line,
                                  overflow: TextOverflow.fade,
                                ),
                                textColor: arrivals[index].realTime == "true" ? Colors.green : Colors.yellow,
                                trailing: Text(arrivals[index].gen_time()),
                              ),
                            );
                          }),
                    ),
                  ),
                ]
              ]).animate().fade(duration: 200.ms),
        ));
  }
}
