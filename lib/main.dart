import 'package:flutter/material.dart';
import 'package:flutter_app_notes/screens/note_detail.dart';
import 'package:flutter_app_notes/screens/note_list.dart';
import 'package:flutter_app_notes/screens/note_detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: NoteList(),
      routes: {
        NoteDetail.routeName: (context) => NoteDetail(),
        NoteList.routeName: (context) => NoteList(),
      },
    );
  }
}
