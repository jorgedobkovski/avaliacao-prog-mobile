import 'package:flutter/material.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class ToDo {
  String title;
  bool isDone;

  ToDo({
    required this.title,
    this.isDone = false,
  });
}

class _TodoListViewState extends State<TodoListView> {
  List<ToDo> todos = [];

  TextEditingController _addTaskController = TextEditingController();
  TextEditingController _editTaskController = TextEditingController();
  String _searchQuery = '';

  void _addTodo(String title) {
    setState(() {
      todos.add(ToDo(title: title));
    });
    Navigator.of(context).pop();
  }

  void _toggleTodoState(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  void _showEditModal(int index) {
    _editTaskController.text = todos[index].title;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: _editTaskController,
            decoration: InputDecoration(hintText: 'Digite o título da tarefa'),
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
                  todos[index].title = _editTaskController.text;
                });
                _editTaskController.clear();
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
    final removedItem = todos.removeAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa removida'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              if (index <= todos.length) {
                todos.insert(index, removedItem);
              } else {
                todos.add(removedItem);
              }
            });
          },
        ),
      ),
    );
  }

  List<ToDo> _filteredTodos() {
    if (_searchQuery.isEmpty) {
      return todos;
    } else {
      return todos.where((todo) =>
          todo.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO'),
        actions: <Widget>[
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
                    key: Key(todos[index].title),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction){
                      if(direction == DismissDirection.startToEnd){
                        _removeTodo(index);
                      }
                      if(direction == DismissDirection.endToStart){
                        _showEditModal(index);
                      }
                    },
                    child: GestureDetector(
                      onTap: () => _toggleTodoState(index),
                      child: ListTile(
                        title: Text(
                          filteredList[index].title,
                          style: TextStyle(
                            decoration: filteredList[index].isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: todos[index].isDone,
                          onChanged: (_) => _toggleTodoState(index),
                        ),
                      ),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
