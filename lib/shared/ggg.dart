

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/Layout/newsapp/cubit/States.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../network/local/cache_helper.dart';
import 'as.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];



  void changeIndex (int index){
    currentIndex=index;
    emit(AppChangeNavBarState());
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  void creatDatabasee()  {
    openDatabase(
      'todoo.db',
      version: 1,
      onCreate: (database, version) {
        print("database created");
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,time TEXT, date TEXT, status TEXT)')
            .then((value) {
          print("table created");
        }).catchError((error) {
          print("error while creating databas ${error.toString()}");
        });
      },
      onOpen: (database) {
        getFromDatabasee(database);
        print("database opened");

      },
    ).then((value){
      database =value;
      emit(AppCreatDatabase());
    });
  }

  insertToDatabase({required String title,required String time,required String date}) async {
    await database.transaction((txn) {
      txn.rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$time","$date","new")',
      ).then((value) {
        print("$value inserted successfully");
        emit(AppInsertDatabase());

        getFromDatabasee(database);
      }).catchError((error) {
        print("Error while inserting to database: ${error.toString()}");
      });
      return Future.value();
    });
  }

  void getFromDatabasee (database) {
    doneTasks=[];
    archivedTasks=[];
    newTasks=[];

    emit(AppGetDatabaseLoadingState());

    database.rawQuery("SELECT * FROM tasks").then((value){

      value.forEach((element) {
        if(element['status']=='new')
        {
          newTasks.add(element);
        }
        else if(element['status']=='done')
        {
          doneTasks.add(element);
        }

        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });

  }

  void statusUpdate({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', '$id'],
    ).then((value)
    {
      getFromDatabasee(database);
      emit(AppUpdateDatabaseState());
    });


  }

  void statusDelete({
    required int id,
  }) async
  {
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      ['$id'],
    ).then((value)
    {
      getFromDatabasee(database);
      emit(AppDeleteDatabaseState());
    });


  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({required bool isShow,required IconData icon})
  {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  bool isDark=false;

  ThemeMode appMode = ThemeMode.dark;

  void changeAppMode ({bool? shared})
  {
    if(shared!=null) {
      isDark = shared;
      emit(AppChangeModeState() as AppStates);
    } else {
      isDark = !isDark;
      CacheHelper.putData(key: 'isDark', value: isDark)
          .then((value) => {emit(AppChangeModeState() as AppStates)});
    }
  }
}