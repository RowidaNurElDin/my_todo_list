import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/Screens/archivedTask_Screen.dart';
import 'package:untitled/Screens/doneTask_Screen.dart';
import 'package:untitled/Screens/newTask_Screen.dart';
import 'package:untitled/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());


  static AppCubit get(context) => BlocProvider.of(context);
  
  int currentScreen = 0;
  List<Widget> screens = [
    newTaskScreen(),
    doneTaskScreen(),
    archcivedTaskScreen()
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  Database database;
  int id = 1 ;
  List<Map> newTasksList = [] ;
  List<Map> doneTasksList = [] ;
  List<Map> archivedTasksList = [] ;


  void changeIndex(){
    emit(AppChangeNavBarState());
  }

  void createDatabase()  {
     openDatabase('tasks.db',
        version: 1,
        onCreate: (database, version) {
          print("db created");
          database.execute(
              'Create table tasks (id Integer ,title Text , date Text , time text , status text)');
          print("Table created");
        }, onOpen: (database) {
          print("DB OPENED");
          getFromDatabase(database);

        }).then((value) {
          database = value;
          emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase(String title , String date , String time) {
    database.transaction((txn){
      txn.rawInsert('Insert into tasks (id,title,date,time,status) values ("$id","$title","$date","$time","new")')
          .then((value){
            id++;
        print("$value INSERTION DONE");
        print(newTasksList);
      }).catchError((error){
        print("error");
      });
      return null;
    });
    getFromDatabase(database);
  }

  void getFromDatabase(database){

    newTasksList = [];
    doneTasksList = [];
    archivedTasksList = [];

    emit(AppEmptyTasksState());
     database.rawQuery('SELECT * FROM tasks').then((value)
     {
       value.forEach((element)
       {
         if(element['status'] == 'new'){
           newTasksList.add(element);
         }else if(element['status'] == 'done'){
           doneTasksList.add(element);
         }else if(element['status'] == 'archived'){
           archivedTasksList.add(element);
         }
       });
       emit(AppGetDatabaseState());
     });
  }

  void updateDatabase({ @required String status,
  @required int id}){

    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getFromDatabase(database);
          emit(AppUpdateDatabaseState());
    });
  }
  
  void deleteData({@required int id}){
    database
        .rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value) {
      getFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

}