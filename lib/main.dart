import 'package:bloc/bloc.dart';
import 'package:bloc_crud/pages/all_task_page.dart';
import 'package:bloc_crud/pages/create_task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';
import 'cubit/observer_bloc.dart';
import 'cubit/task_cubit.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();

  BlocOverrides.runZoned( () {
    runApp(MyApp());


  },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create:(BuildContext context )=> AppBloc()..CreatDataBase())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme:ThemeData.light(),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
          onPressed: (() {
            // NavigateTo(context: context,router:  CreateTaskPage());
            NavigateTo(context: context,router:  AllScreen());
          }),
          // child: Text("Create Task"),
          child: Text("All Task"),
        )
    );
  }
}
