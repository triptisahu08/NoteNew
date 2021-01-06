import 'package:flutter/material.dart';
import 'package:flutter_app_notes/models/note.dart';
import 'package:flutter_app_notes/utils/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;
  final _formKey = GlobalKey<FormState>();

/*
Variable for image picker
 */
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  // First element (Priority Selector)

                  ListTile(
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser');
                            updatePriorityAsInt(valueSelectedByUser);
                          });
                        }),
                  ),

                  // Second Element (Title)
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Title Required';
                        }

                        return null;
                      },
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          hintText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Third Element (Description)
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.length <= 10) {
                          return 'Valid Description Required';
                        }

                        return null;
                      },
                      maxLines: 1,
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in Description Text Field');
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          hintText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Fourth Element (Image Picker Icon Button)
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        IconButton(
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
                                          child:
                                              const Text('Pick From Gallery'),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); //close the dialog box
                                            _getImage(ImageSource.camera);
                                          },
                                          child:
                                              const Text('Take A New Picture'),
                                        ),
                                      ]);
                                });
                            // setState(() {
                            //
                            // });
                          },
                        ),
                        SizedBox(width: 10.0),
                        _imageFile != null
                            ? Image.asset(
                                _imageFile.path,
                                height: 100,
                              )
                            : Image.asset(
                                'assets/no_image.png',
                                height: 100,
                              )
                      ],
                    ),
                  ),

                  // Fifth Element (Button)
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
                                if (_formKey.currentState.validate()) {
                                  _save();
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        note.id != null
                            ? Expanded(
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColorDark,
                                  textColor:
                                      Theme.of(context).primaryColorLight,
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
          ),
        ));
  }

  _getImage(ImageSource src) async {
    debugPrint(src.toString());
    try {
      final pickedFile = await _picker.getImage(source: src);
      setState(() {
        _imageFile = pickedFile;
      });
      print(_imageFile);
      debugPrint(pickedFile.toString());
      note.imagePath = _imageFile.path;
      print(note.imagePath);
    } catch (exception) {
      debugPrint(exception.toString());
    }
  }

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
