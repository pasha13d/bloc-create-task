import 'package:bloc_crud/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppBloc,AppStates>(
        listener: (BuildContext context,AppStates state){},
        builder: (BuildContext context,AppStates state) {
          AppBloc cubit =AppBloc.get(context);
          var Tasks= cubit.allTasks;

          print('length : ${AppBloc.get(context).allTasks.length}');
          return  AppBloc.get(context).allTasks.isEmpty
              ? Center(
            child: Text('No Record Found'),
          )
              : Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                AppBloc.get(context).GetDataFromDataBase(cubit.db);
              },
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return BuildTask(
                    item: AppBloc.get(context).allTasks[index],color: cubit.colorslist[index % cubit.colorslist.length],);
                  },
                  itemCount: AppBloc.get(context).allTasks.length,
              ),
            ),
          );

        });
  }
}

class BuildTask extends StatelessWidget {
  final Map item;
  final Color color ;
  const BuildTask({Key? key ,required this.item ,required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('${item['title']}'));
  }
}
