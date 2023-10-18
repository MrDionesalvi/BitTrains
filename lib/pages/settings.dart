import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:moj_lpp/prefrences.dart';
import 'package:moj_lpp/stops.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Stop home = Stops.all_stops.first;
  Stop school = Stops.all_stops.last;
  String line = "18";
  final TextEditingController homeController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GetSettings();
  }

  GetSettings() {
    print("GetSettings");

    setState(() {
      school = BusStopUserPrefrences.get_school();
      print("Schhol: ${school.value}");
      home = BusStopUserPrefrences.get_home();
      line = BusStopUserPrefrences.get_line();

      schoolController.text = BusStopUserPrefrences.get_custom_label_school();
      homeController.text = BusStopUserPrefrences.get_custom_label_home();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        title: Text("Settings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Text(
                "To ${BusStopUserPrefrences.get_custom_label_school()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.all(12)),
              TextField(
                controller: homeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Custom label",
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              DropdownSearch<Stop>(
                items: Stops.all_stops,
                selectedItem: home,
                itemAsString: (Stop s) => s.gen_name().name,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(color: Colors.white),
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey.shade700, width: 5)))),
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
                    home = s;
                  }
                },
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                "To ${BusStopUserPrefrences.get_custom_label_home()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Padding(padding: EdgeInsets.all(12)),
              TextField(
                controller: schoolController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Custom label",
                  labelStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade800),
                      borderRadius: BorderRadius.circular(3)),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              DropdownSearch<Stop>(
                items: Stops.all_stops,
                selectedItem: school,
                itemAsString: (Stop s) => s.gen_name().name,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(color: Colors.white),
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey.shade700, width: 5)))),
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
                    school = s;
                  }
                },
              ),
              Padding(padding: EdgeInsets.all(5)),
              DropdownSearch<String>(
                items: Stops.lines,
                selectedItem: line,
                dropdownDecoratorProps: DropDownDecoratorProps(
                    baseStyle: TextStyle(color: Colors.white),
                    dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey.shade700, width: 5)))),
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) {
                      return SizedBox(
                        height: 60,
                        child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16
                                      // Change the text color based on selection
                                      ),
                                ),
                              ]),
                        ),
                      );
                    },
                    searchFieldProps: TextFieldProps(
                      style: TextStyle(color: Colors.white),
                    ),
                    modalBottomSheetProps: ModalBottomSheetProps(
                      backgroundColor: Colors.blueGrey.shade900,
                    ),
                    listViewProps: ListViewProps(),
                    searchDelay: Duration(milliseconds: 50)),
                onChanged: (String? s) {
                  if (s != null) {
                    setState(() {
                      line = s;
                    });
                  }
                },
              ),
              Padding(padding: EdgeInsets.all(15)),
              TextButton(
                  onPressed: () async {
                    try {
                      await BusStopUserPrefrences.set_home(home);

                      await BusStopUserPrefrences.set_school(school);
                      await BusStopUserPrefrences.set_line(line);
                      print(line);
                      await BusStopUserPrefrences.set_custom_label_home(
                          homeController.text);
                      await BusStopUserPrefrences.set_custom_label_school(
                          schoolController.text);

                      setState(() {
                        school = BusStopUserPrefrences.get_school();

                        home = BusStopUserPrefrences.get_home();
                        line = BusStopUserPrefrences.get_line();

                        schoolController.text =
                            BusStopUserPrefrences.get_custom_label_school();
                        homeController.text =
                            BusStopUserPrefrences.get_custom_label_home();
                      });

                      AwesomeDialog(
                        context: context,
                        titleTextStyle: TextStyle(color: Colors.white),
                        descTextStyle: TextStyle(color: Colors.white),
                        dialogBackgroundColor: Colors.blueGrey.shade800,
                        dialogType: DialogType.success,
                        animType: AnimType.scale,
                        title: 'Success!',
                        desc: 'Saved preferences succesfully!',
                        btnOkOnPress: () {},
                      ).show();
                    } catch (e) {
                      AwesomeDialog(
                        context: context,
                        titleTextStyle: TextStyle(color: Colors.white),
                        descTextStyle: TextStyle(color: Colors.white),
                        dialogBackgroundColor: Colors.blueGrey.shade800,
                        dialogType: DialogType.error,
                        animType: AnimType.scale,
                        title: 'Error',
                        desc: 'Ann error occured while saving preferences!',
                        btnOkColor: Colors.red,
                        btnOkOnPress: () {},
                      ).show();
                    }
                    print("Set stops");
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade700),
                  child: SizedBox(
                    child: Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(),
                      ),
                    ),
                    width: 150,
                    height: 50,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
