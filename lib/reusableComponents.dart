import 'package:flutter/material.dart';
import 'package:untitled/cubit/cubit.dart';
import 'Constants.dart';
import 'package:condition/condition.dart';

class TaskTile extends StatelessWidget {
  Map task ;
  TaskTile(this.task);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task['id'].toString()),
      onDismissed: (direction){
        AppCubit.get(context).deleteData(id: task['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              shape: CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation:5.0 ,
              child: CircleAvatar(
                backgroundColor: Color(0xFFf5bb6c),
                radius: 40.0,
                child: Text("${task['time']}",
                  style: TextStyle(
                    color: Constants.color,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    fontFamily: 'KleeOne'
                  ),),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "${task['title']}",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KleeOne'

                    ),
                  ),
                ),
                Text(
                  "${task['date']}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontFamily: 'KleeOne'

                  ),
                )
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
            Conditioned(
              defaultBuilder: () => Container(),
              cases: [
                Case(task['status'] == 'new', builder: () => IconButton(
                    onPressed: (){
                      AppCubit.get(context).updateDatabase(status: 'done' , id: task['id']);
                    },
                    icon: Icon(Icons.check_box, color: Colors.green,)
                )),
              ],
            )  ,
            Conditioned(
                defaultBuilder: () => Container(),
              cases: [
                Case(task['status'] == 'new' || task['status'] == 'done' ,
                    builder: () => IconButton(
                        onPressed: (){
                          AppCubit.get(context).updateDatabase(status: 'archived' , id: task['id']);
                        },
                        icon: Icon(Icons.archive_outlined, color: Colors.blueGrey,)
                    ) )
              ],
            ),



          ],
        ),
      ),
    );
  }
}

class modalSheetTextField extends StatelessWidget {
  const modalSheetTextField({
    Key key,
    @required this.controller,
    @required this.isselected,
    @required this.fn,
    @required this.text,
    @required this.icon,
    this.focusNode
  }) : super(key: key);

  final TextEditingController controller;
  final bool isselected;
  final Function fn;
  final String text ;
  final FocusNode focusNode;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      onTap: fn,
      controller: controller,
      style: TextStyle(
          fontSize: 25.0,
          fontFamily: 'KleeOne',
          color: Constants.color

      ),
      cursorColor: Constants.color,
      decoration: InputDecoration(

          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Constants.color, width: 1),
          ) ,
          icon: Icon(icon,
            color: isselected ? Constants.color : Colors.grey[600],
          ),
          hintText: text,
          hintStyle: TextStyle(
              fontSize: 25.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'KleeOne'
          )),
    );
  }
}
