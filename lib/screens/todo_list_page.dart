import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_with_api/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List toDoItems = [];

  @override
  void initState() {
    super.initState();
    fetchTodoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodoData,
          child: ListView.builder(
            itemCount: toDoItems.length,
            itemBuilder: (context, index) {
              final item = toDoItems[index] as Map;
              final todoId = item['_id'] as String; // todo id eka gannawa
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(
                  // dot 3 return krnne
                  onSelected: (value) {
                    if (value == 'edit') {
                      // Edit the todo item
                      navigateToEditTodoPage(item); //selected item eka gannawa
                    } else if (value == 'delete') {
                      // Delete the todo item
                      deleteTodoById(todoId);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
        //data load wenakan loading indicator eka display wenawa
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddTodoPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToAddTodoPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(
        context, route); //add page idl eddi data load krnw automaticaly
    setState(() {
      isLoading = true;
    });
    fetchTodoData();
  }

  Future<void> navigateToEditTodoPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todoItem: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodoData();
  }

  Future<void> fetchTodoData() async {
    // Fetch the data from the server
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      //items kiyl danne data enne 'items' kiyl list eke

      setState(() {
        toDoItems = result;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTodoById(String todoId) async {
    //delete the todo item
    final url = 'https://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      //remove the todo item from the list
      final filterdItems =
          toDoItems.where((element) => element['_id'] != todoId).toList();
      setState(() {
        toDoItems = filterdItems;
      });
      fetchTodoData();
    } else {
      //show error message
      showErrorMessage('Failed to delete todo');
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
