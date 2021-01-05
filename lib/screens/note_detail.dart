import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app_notes/models/note.dart';
import 'package:flutter_app_notes/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  static const routeName = '/noteDetail';

  final String appBarTitle;
  final Note note;

  NoteDetail({Key key, this.note, this.appBarTitle}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState();
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState({this.note, this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note != null ? note.title : "";
    descriptionController.text = note != null ? note.description : "";

    String aT = appBarTitle ?? "";
    return WillPopScope(
        onWillPop: () {
          // ignore: missing_return
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(aT),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
<<<<<<< Updated upstream
                // First element
=======
                // First element (Priority Selector)

>>>>>>> Stashed changes
                ListTile(
                  title: DropdownButton(
                      items: _priorities.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }).toList(),
                      style: textStyle,
                      value:
                          getPriorityAsString(note != null ? note.priority : 2),
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          debugPrint('User selected $valueSelectedByUser');
                          updatePriorityAsInt(valueSelectedByUser);
                        });
                      }),
                ),

                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

<<<<<<< Updated upstream
                // Fourth Element
=======
                // Fourth Element (Image Picker Icon Button)
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: IconButton(
                    icon: Icon(Icons.image_search_sharp),
                    iconSize: 50,
                    color: Colors.brown,
                    tooltip: 'Select/Capture Image',
                    onPressed: () {
                      debugPrint("Icon Button Clicked");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                                title: Text("Camera/Gallery"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); //close the dialog box
                                      _getImage(ImageSource.gallery);
                                    },
                                    child: const Text('Pick From Gallery'),
                                  ),
                                  SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); //close the dialog box
                                      _getImage(ImageSource.camera);
                                    },
                                    child: const Text('Take A New Picture'),
                                  ),
                                ]);
                          });
                      // setState(() {
                      //
                      // });
                    },
                  ),
                ),

                // Fifth Element (Button)
>>>>>>> Stashed changes
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      note != null
                          ? Expanded(
                              child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  'Delete',
                                  textScaleFactor: 1.5,
                                ),
                                onPressed: () {
                                  setState(() {
                                    debugPrint("Delete button clicked");
                                    _delete();
                                  });
                                },
                              ),
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

<<<<<<< Updated upstream
=======
  _getImage(ImageSource src) async {
    debugPrint(src.toString());
    try {
      final pickedFile = await _picker.getImage(source: src);
      setState(() {
        _imageFile = pickedFile;
      });
      debugPrint(_imageFile.path);
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

>>>>>>> Stashed changes
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updateNote(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Delete This Note?"),
              content:
                  Text('This Note Will Be Deleted Permanently. Are You Sure?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () {
                    Navigator.pop(context);
                    helper.deleteNote(note.id).then((value) {
                      moveToLastScreen();
                      _showAlertDialog('Status', 'Note Deleted Successfully');
                    }).catchError((onError) {
                      print("error");
                      _showAlertDialog(
                          'Status', 'Error Occurred While Deleting the Note');
                    });
                  },
                ),
              ],
            ));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
