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

class _TodoListState extends State<TodoList> {
  List<String> _todoList = <String>[];
  final TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textEdit = TextEditingController();
  AudioPlayer advancedPlayer;
  String listKey = "listKey";

  Future loadMusic() async {
    advancedPlayer = await AudioCache().play("Ping.mp3");
  }

  void storeStringList(List<String> _todoList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(listKey, _todoList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        splashColor: Colors.orange,
        tooltip: 'Add Task',
        child: Icon(
          Icons.add,
          size: 45,
          color: Colors.yellow,
        ),
      ),
    );
  }

  void _addTodoItem(String title) {
    // Wrapping it inside a set state will notify
    // the app that the state has changed
    setState(() => _todoList.insert(0,title));
    _textFieldController.clear();
  }

  void taskDone(String title) {
    setState(
      () {
        loadMusic();
        _todoList.remove(title);
      },
    );
  }

  // Generate list of item widgets
  Widget _buildTodoItem(String title) {
    return Card(
      color: Color(0xff141111),
      elevation: 5,
      child: Row(
        children: <Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: RaisedButton(
                onPressed: () {
                  taskDone(title);
                },
                color: Color(0xff141111),
                shape: CircleBorder(
                  side: BorderSide(color: Colors.yellow, width: 4),
                ),
                splashColor: Colors.orange,
              ),
            ),
          ),
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
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
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
                          FlatButton(
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
                          FlatButton(
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
                color: Color(0xff141111),
                splashColor: Colors.orange,
                child: Icon(
                  Icons.edit,
                  size: 35,
                  color: Colors.yellow,
                ),
              ),
            ),
          ),
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
            FlatButton(
              child: const Text('ADD',
              style: TextStyle(color: Colors.yellow),),
              onPressed: () {
                if (_textFieldController.text != '') {
                  Navigator.of(context).pop();
                  _addTodoItem(_textFieldController.text);
                }
              },
            ),
            FlatButton(
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

  List<Widget> _getItems() {
    storeStringList(_todoList);
    getStringList();
    final List<Widget> _todoWidgets = <Widget>[];
    for (String title in _todoList) {
      _todoWidgets.add(_buildTodoItem(title));
    }
    return _todoWidgets;
  }
}
