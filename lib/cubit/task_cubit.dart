import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

part 'task_state.dart';

class AppBloc extends Cubit<AppStates> {
  AppBloc() : super(InitialAppState());
  static AppBloc get(context) => BlocProvider.of(context);

  late Database db;

  TextEditingController TitleController = TextEditingController();
  TextEditingController DatelineController = TextEditingController();
  TextEditingController StartTimeController = TextEditingController();
  TextEditingController EndTimeController = TextEditingController();
  TextEditingController RemindController = TextEditingController();
  TextEditingController RepeatController = TextEditingController();
  DateTime selectedDateNow = DateTime.now();

  List<Map> allTasks = [];
  List<Map> CompletedTasks = [];
  List<Map> UnCompletedTasks = [];
  List<Map> FavoriteTask = [];

  List <Color> colorslist = [
    Colors.blue.shade400,
    Colors.pink.shade400,
    Colors.orange.shade400,
    Colors.yellow.shade600
  ];

  ///Create and Open DataBase and Table
  void CreatDataBase() async {
    await openDatabase(
      'Todo.db',
      version: 1,
      onCreate: (database, version) async {
        debugPrint('DataBase is Created');
        await database
            .execute(
            'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, dateline TEXT, starttime TEXT, endtime TEXT,remind TEXT,repreat TEXT ,iscompleted INTEGER , is_fav TEXT,status TEXT)')
            .then((value) {
          debugPrint('Table created');
          emit(AppDataBaseTableCreatedState());
        }).catchError((error) {
          debugPrint('Error when Create Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        db = database;
        GetDataFromDataBase(db);
        debugPrint('open DataBase');
      },
    ).then((value) {
      db = value;
      emit(AppCreateDataBaseState());
    });
  }

  void InsertDataBase({ bool isFav =false}) async {
    await db.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Tasks(title, dateline,starttime,endtime,remind,repreat,iscompleted,status, is_fav) VALUES("${TitleController.text}"," ${DatelineController.text}", "${StartTimeController.text}","${EndTimeController.text}","${RemindController.text}","${RepeatController.text}","0","unCompleted" ,"${isFav}")')
          .then((value) {
        debugPrint('$value insert succefuly');
        TitleController.clear();
        DatelineController.clear();
        StartTimeController.clear();
        EndTimeController.clear();
        RemindController.clear();
        RepeatController.clear();
        GetDataFromDataBase(db);
        emit(AppInsertDataBaseState());
      }).catchError((error) {
        debugPrint('Error when insert new  ${error.toString()}');
      });
    });
  }

  void GetDataFromDataBase(db) async {
    allTasks = [];
    CompletedTasks=[];
    UnCompletedTasks=[];
    FavoriteTask = [];
    emit(AppGetDataBaseLoadingState());
    db.rawQuery('SELECT * FROM Tasks').then((value) {
      allTasks = value;
      value.forEach((element) {
        if (element['status'] == 'completed') {
          CompletedTasks.add(element);
        }
        else if (element['status'] == 'unCompleted') {
          UnCompletedTasks.add(element);
        }
        if (element['is_fav'] == 'true') {
          FavoriteTask.add(element);
        }
      });
      debugPrint(allTasks.toString());
      emit(AppGetDataBaseState());
    });
  }

}