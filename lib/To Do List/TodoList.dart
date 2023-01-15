import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

//StatefulWidget (for dynamic pages) always has 2 classes, the above is still immutable (like the StatelessWidget, for static pages)
//but the below class is mutable

class _TodoListState extends State<TodoList> {

  List<String> _todoList = <String>[];
  List<String> _todoSpecialList = <String>[];
  List<String> _completedList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textEdit = TextEditingController();
  AudioPlayer advancedPlayer;
  String listKey = "listKey";
  String speciallistKey = "speciallistKey";
  String completedlistKey = "completedlistKey";

  Future loadMusic() async {
    advancedPlayer = await AudioCache().play("reaverkill.mp3");
  }

  Future specialloadMusic() async {
    advancedPlayer = await AudioCache().play("primeace.mp3");
  }

  Future pingloadMusic() async {
    advancedPlayer = await AudioCache().play("Ping.mp3");
  }

  void storeStringList(List<String> _todoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(listKey, _todoList);
  }

  void storeSpecialStringList(List<String> _todoSpecialList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(speciallistKey, _todoSpecialList);
  }

  void getStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        if (prefs.getStringList(listKey) != null) {
          _todoList = prefs.getStringList(listKey);
        }
      },
    );
  }

  void getSpecialStringList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
          () {
        if (prefs.getStringList(speciallistKey) != null) {
          _todoSpecialList = prefs.getStringList(speciallistKey);
        }
      },
    );
  }

  void _addTodoItem(String title) {
    setState(() => _todoList.insert(0,title));
    _textFieldController.clear();
    storeStringList(_todoList);
  }

  void _addSpecialTodoItem(String title) {
    setState(() => _todoSpecialList.insert(0,title));
    _textFieldController.clear();
    storeSpecialStringList(_todoSpecialList);
  }

  void taskDone(String title) {
    setState(
          () {
        _todoList.remove(title);

      },
    );
    storeStringList(_todoList);
  }

  void specialtaskDone(String title) {
    setState(
          () {
        _todoSpecialList.remove(title);

      },
    );
    storeSpecialStringList(_todoSpecialList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold,
                           color: Colors.yellow),
        ),
      ),
      body: ListView(children: _getItems()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        backgroundColor: Color(0xff141111),
        splashColor: Colors.pink,
        tooltip: 'Add Task',
        child: Icon(
          Icons.add,
          size: 45,
          color: Colors.yellow,
        ),
      ),
    );
  }

  // Generate list of regular item widgets
  Widget _buildTodoItem(String title) {
    return Card(
      color: Color(0xff141111),
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _completedList.insert(0,title);
                    taskDone(title);
                    loadMusic();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff141111)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(CircleBorder(
                      side: BorderSide(color: Colors.yellow, width: 4),
                    ),
                  ),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            child: Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Color(0xff141111),
                          title: const Text(
                            'Edit task:',
                            style: TextStyle(color: Colors.yellow),
                          ),
                          content: TextField(
                            maxLines: 3,
                            showCursor: true,
                            style: TextStyle(color: Colors.white),
                            controller: _textEdit =
                                TextEditingController(text: title),
                            decoration: const InputDecoration(
                                hintText: 'Enter task here.',
                                hintStyle: TextStyle(color: Color(0xff696969))),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('SAVE',
                              style: TextStyle(color: Colors.yellow),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(
                                      () {
                                    _todoList.remove(title);
                                  },
                                );
                                _addTodoItem(_textEdit.text);
                              },
                            ),
                            TextButton(
                              child: const Text('CANCEL',
                              style: TextStyle(color: Colors.yellow),),
                              onPressed: () {
                                _textFieldController.text = '';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }, //builder
                    ); //showDialog
                  }, //onPressed
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff141111)),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 35,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
          //star icon
          SizedBox(
            width: 50,
            child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    _addSpecialTodoItem(title);
                    taskDone(title);
                    pingloadMusic();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xff141111)),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  ),
                  child: Icon(
                    Icons.star_border,
                    size: 35,
                    color: Colors.yellow,
                  ),
                ),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  // Generate list of special item widgets
  Widget _buildSpecialTodoItem(String title) {
    return Card(
      color: Colors.yellow,
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _completedList.insert(0,title);
                    specialtaskDone(title);
                    specialloadMusic();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                    shape: MaterialStateProperty.all<OutlinedBorder>(CircleBorder(
                      side: BorderSide(color: Colors.black, width: 4),
                    ),
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            child: Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xff141111),
                        title: const Text(
                          'Edit task:',
                          style: TextStyle(color: Colors.yellow),
                        ),
                        content: TextField(
                          maxLines: 3,
                          showCursor: true,
                          style: TextStyle(color: Colors.white),
                          controller: _textEdit =
                              TextEditingController(text: title),
                          decoration: const InputDecoration(
                              hintText: 'Enter task here.',
                              hintStyle: TextStyle(color: Color(0xff696969))),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('SAVE',
                              style: TextStyle(color: Colors.yellow),),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(
                                    () {
                                  _todoSpecialList.remove(title);
                                },
                              );
                              _addSpecialTodoItem(_textEdit.text);
                            },
                          ),
                          TextButton(
                            child: const Text('CANCEL',
                              style: TextStyle(color: Colors.yellow),),
                            onPressed: () {
                              _textFieldController.text = '';
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }, //builder
                  ); //showDialog
                }, //onPressed
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  elevation: MaterialStateProperty.all(0.0),
                ),
                child: Icon(
                  Icons.edit,
                  size: 35,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  _addTodoItem(title);
                  specialtaskDone(title);
                  pingloadMusic();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  elevation: MaterialStateProperty.all(0.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.star,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  // Generate list of completed item widgets
  Widget _buildCompletedTodoItem(String title) {
    return Card(
      color: Colors.pink,
      elevation: 5,
      child: Row(
        children: <Widget>[
          //Undo button
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _todoList.insert(0,title);
                    storeStringList(_todoList);
                    _completedList.remove(title);
                    //undo music
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.undo,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            child: Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  _completedList.remove(title);
                  //delete music
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.pink),
                  elevation: MaterialStateProperty.all(0.0),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10)
        ],
      ),
    );
  }

  // Generate a single item widget
  Future<AlertDialog> _displayDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff141111),
          title: const Text(
            'Add task:',
            style: TextStyle(color: Colors.yellow),
          ),
          content: TextField(
            maxLines: 3,
            style: TextStyle(color: Colors.white),
            controller: _textFieldController,
            decoration: const InputDecoration(
                hintText: 'Enter task here.',
                hintStyle: TextStyle(color: Color(0xff696969))),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ADD',
              style: TextStyle(color: Colors.yellow),),
              onPressed: () {
                if (_textFieldController.text != '') {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                }
              },
            ),
            TextButton(
              child: const Text('CANCEL',
              style: TextStyle(color: Colors.yellow),),
              onPressed: () {
                _textFieldController.text = '';
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //display list of todo items
  List<Widget> _getItems() {

    getStringList();
    getSpecialStringList();

    final List<Widget> _todoWidgets = <Widget>[];

    for (String title in _todoSpecialList) {
      _todoWidgets.add(_buildSpecialTodoItem(title));
    }

    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }

    for (String title in _completedList) {
      _todoWidgets.add(_buildCompletedTodoItem(title));
    }

    return _todoWidgets;
  }
}
