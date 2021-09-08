import 'package:flutter/material.dart';
import 'package:untitled/Screens/archivedTask_Screen.dart';
import 'package:untitled/Screens/doneTask_Screen.dart';
import 'package:untitled/Screens/newTask_Screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:untitled/cubit/cubit.dart';
import 'package:untitled/cubit/states.dart';
import '../Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:condition/condition.dart';

import '../reusableComponents.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController title_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();
  TextEditingController time_controller = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isEnabled = true;
  bool textselected = false;
  bool dateselected = false;
  bool timeselected = false;
  FocusNode focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              elevation: 10.0,
              backgroundColor: Constants.color,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Container(
                      color: Color(0xff757575),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            padding: EdgeInsets.all(60.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0))),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                modalSheetTextField(
                                  controller: title_controller,
                                  isselected: textselected,
                                  fn: () {
                                    textselected = !textselected;
                                  },
                                  text: 'Task to be done',
                                  icon: Icons.text_fields,
                                ),
                                modalSheetTextField(
                                  controller: date_controller,
                                  isselected: dateselected,
                                  fn: () {
                                    focusNode.unfocus();
                                    dateselected = !dateselected;
                                    showDatePicker(
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  primaryColor: Constants.color,
                                                  accentColor: Constants.color,
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary:
                                                              Constants.color),
                                                  buttonTheme: ButtonThemeData(
                                                      textTheme: ButtonTextTheme
                                                          .primary),
                                                ),
                                                child: child,
                                              );
                                            },
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2021-09-15'))
                                        .then((value) {
                                      date_controller.text = formatDate(
                                          value, [d, '-', M, '-', yyyy]);
                                    });
                                  },
                                  text: "Date",
                                  icon: Icons.calendar_today_sharp,
                                  focusNode: focusNode,
                                ),
                                modalSheetTextField(
                                  controller: time_controller,
                                  isselected: timeselected,
                                  fn: () {
                                    focusNode.unfocus();
                                    timeselected = !timeselected;
                                    showTimePicker(
                                            builder: (BuildContext context,
                                                Widget child) {
                                              return Theme(
                                                data:
                                                    ThemeData.light().copyWith(
                                                  primaryColor: Constants.color,
                                                  accentColor: Constants.color,
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary:
                                                              Constants.color),
                                                  buttonTheme: ButtonThemeData(
                                                      textTheme: ButtonTextTheme
                                                          .primary),
                                                ),
                                                child: child,
                                              );
                                            },
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      time_controller.text =
                                          value.format(context).toString();
                                    });
                                  },
                                  text: 'Time',
                                  icon: Icons.watch_later,
                                  focusNode: focusNode,
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    cubit.insertToDatabase(
                                        title_controller.text,
                                        date_controller.text,
                                        time_controller.text);
                                    Navigator.pop(context);
                                    title_controller.text = "";
                                    date_controller.text = "";
                                    time_controller.text = "";
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            side: BorderSide(
                                                color: Constants.color))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Constants.color),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          fontFamily: 'KleeOne'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.playlist_add_sharp),
            ),
            body: state is AppEmptyTasksState
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentScreen],
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Constants.color,
              centerTitle: true,
              title: Text(
                cubit.titles[cubit.currentScreen],
                style: TextStyle(
                    fontFamily: 'KleeOne',
                    fontWeight: FontWeight.bold,
                    fontSize: 27),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Constants.color,
              onTap: (index) {
                cubit.changeIndex();
                cubit.currentScreen = index;
              },
              elevation: 10.0,
              currentIndex: cubit.currentScreen,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list_outlined,
                    ),
                    label: 'New'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_box_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
