import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_notes/models/note.dart';
import 'package:flutter_app_notes/utils/database_helper.dart';
import 'package:flutter_app_notes/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';


class NoteList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Notes'),
      ),

      body: getNoteListView(),
      drawer: new Drawer(
        elevation: 20.0,
        child:new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                  children: [Icon(Icons.sticky_note_2_sharp,size: 60.0,color: Colors.teal,),
                    SizedBox(width: 30.0,),
                    Text('NOTES',style: TextStyle(color: Colors.black87,fontSize: 24.0,),),
                    Divider(thickness: 3.0,
                      color: Colors.black,
                      height: 2.0,
                      indent: 2.0,),
                 ], ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              //   image: DecorationImage(
              //   image: AssetImage('assets/logo.png'),
              //   fit: BoxFit.scaleDown,
              // ),
              gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
               colors:[Colors.teal[600], Colors.tealAccent],
               ),
                ),
            ),
            ListTile(
              leading: Icon(Icons.fiber_new_rounded,color: Colors.teal[600],),
              title: Text('New Note',style: TextStyle(fontSize: 16.0,),),
              subtitle: Text('Create your note here!'),
              onTap: (){
                //alertDialog();
                Navigator.pop(context);
                navigateToDetail(Note('', '', 2), 'Add Note');
              },
            ),
            new Divider(
              height: 10.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Text('Backup',style: TextStyle(fontSize: 16.0,),),
              leading: Icon(Icons.backup_rounded,color: Colors.teal[600],),
              subtitle: Text('Backup your data on cloud!'),
              onTap: (){
                alertDialog();
              },
            ),
            new Divider(
              height: 10.0,
              thickness: 1.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Text('Restore',style: TextStyle(fontSize: 16.0,),),
              leading: Icon(Icons.restore_page_rounded,color: Colors.teal[600],),
              subtitle: Text('Restore your data from cloud!'),
              onTap: (){
                alertDialog();
              },
            ),
            new Divider(
              height: 10.0,
              thickness: 1.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Text('Wipe Data',style: TextStyle(fontSize: 16.0,),),
              leading: Icon(Icons.auto_delete,color: Colors.teal[600],),
              subtitle: Text('Wipe all your data on cloud!'),
              onTap: (){
                alertDialog();

              },
            ),
            new Divider(
              height: 10.0,
              thickness: 1.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Text('Clear Local Data',style: TextStyle(fontSize: 16.0,),),
              leading: Icon(Icons.cleaning_services_rounded,color: Colors.teal[600],),
              hoverColor: Colors.brown,
              subtitle: Text('Clear your local app data!'),
              onTap: (){
                alertDialog();

              },
            ),
            new Divider(
              height: 10.0,
              thickness: 1.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Text('Close',style: TextStyle(fontSize: 16.0,),),
              leading: Icon(Icons.close,color: Colors.teal[600],),
              hoverColor: Colors.brown,
              subtitle: Text('Click here to close!'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            new Divider(
              height: 10.0,
              thickness: 1.0,
              color: Colors.teal[600],
              indent: 10.0,
            ),
            ListTile(
              title: Center(child: Text('Copyright@MobilityTeam ')),
            )
          ],
        ),

      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Note('', '', 2), 'Add Note');
        },

        tooltip: 'Add Note',

        child: Icon(Icons.add),

      ),
    );
  }

  ListView getNoteListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),

            title: Text(this.noteList[position].title, style: titleStyle,),

            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position],'Edit Note');
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }
  void alertDialog()
  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Alert Dialog Box"),
        content: Text("Work in Progress....."),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("okay",style: TextStyle(color:Colors.teal),),
          ),
        ],
      ),
    );
  }
  void _delete(BuildContext context, Note note) async {

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}