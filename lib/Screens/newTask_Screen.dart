import 'package:condition/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/cubit/cubit.dart';
import 'package:untitled/cubit/states.dart';
import 'package:untitled/reusableComponents.dart';

import '../Constants.dart';

class newTaskScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      BlocConsumer<AppCubit,AppStates>(
        listener: (context , state){},
        builder: (context,state){
          return
            Conditioned(
              defaultBuilder: () => ListView.separated(
                  itemBuilder: (context,index) => TaskTile(AppCubit.get(context).newTasksList[index]),
                  separatorBuilder: (context,index) => Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                  itemCount: AppCubit.get(context).newTasksList.length),
              cases: [
                Case( AppCubit.get(context).newTasksList.isEmpty ,
                    builder: () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.list_outlined,
                            size: 200.0,
                            color: Constants.color.withOpacity(0.5),
                          ),
                        ),
                        Text('No new tasks yet.', style: TextStyle(
                            fontFamily: 'KleeOne',
                            fontSize: 15.0
                        ),)
                      ],
                    )
                )
              ],
            ) ;
        },


      )
    ;
  }
}



