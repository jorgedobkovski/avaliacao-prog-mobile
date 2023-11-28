import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todoItem.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}
class _TodoListViewState extends State<TodoListView> {
  List<ToDo> _todos = [
    ToDo(task: 'Ouvir o novo album do Angra', isDone: false),
    ToDo(task: 'Fazer prova de Programação Mobile', isDone: true),
    ToDo(task: 'Lavar a louça', isDone: true),
  ];

  TextEditingController _addTaskController = TextEditingController();
  TextEditingController _editTaskController = TextEditingController();
  String _searchQuery = '';
  bool _showSearchBar = false;

  void _addTodo(String title) {
    setState(() {
      _todos.add(ToDo(task: title));
    });
    _saveData();
    Navigator.of(context).pop();
  }

  void _toggleTodoState(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
    _saveData();
  }

  void _showEditModal(int index) {
    _editTaskController.text = _todos[index].task;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: _editTaskController,
            decoration: InputDecoration(hintText: 'Digite uma tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _todos[index].task = _editTaskController.text;
                });
                _editTaskController.clear();
                _saveData();
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removeTodo(int index) {
    final removedItem = _todos.removeAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa removida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              if (index <= _todos.length) {
                _todos.insert(index, removedItem);
              } else {
                _todos.add(removedItem);
              }
            });
            _saveData();
          },
        ),
      ),
    );
  }

  List<ToDo> _filteredTodos() {
    if (_searchQuery.isEmpty) {
      return _todos;
    } else if (_searchQuery.startsWith('[true]')) {
      return _todos.where((todo) => todo.isDone).toList();
    } else if (_searchQuery.startsWith('[false]')) {
      return _todos.where((todo) => !todo.isDone).toList();
    } else {
      return _todos
          .where((todo) =>
              todo.task.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');

    if (todosString != null) {
      final List<dynamic> decoded = jsonDecode(todosString);
      setState(() {
        _todos = decoded.map((item) => ToDo.fromMap(item)).toList();
      });
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_todos.map((todo) => todo.toMap()).toList());
    prefs.setString('todos', encoded);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO'),
        actions: <Widget>[
          if (_showSearchBar)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              child: SizedBox(
                width: 210,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar tarefa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.purple,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Adicionar task'),
                    content: TextField(
                      controller: _addTaskController,
                      decoration:
                      InputDecoration(hintText: 'Digite uma tarefa'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _addTodo(_addTaskController.text);
                          _addTaskController.clear();
                        },
                        child: Text('Adicionar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTodos().length,
              itemBuilder: (BuildContext context, int index) {
                final filteredList = _filteredTodos();
                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        _removeTodo(index);
                      }
                      if (direction == DismissDirection.endToStart) {
                        _showEditModal(index);
                      }
                    },
                    child: GestureDetector(
                      onTap: () => _toggleTodoState(index),
                      child: ListTile(
                        title: Text(
                          filteredList[index].task,
                          style: TextStyle(
                            decoration: filteredList[index].isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: filteredList[index].isDone,
                          onChanged: (_) => _toggleTodoState(index),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
