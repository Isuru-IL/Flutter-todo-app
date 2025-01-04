import 'package:flutter/material.dart';
import 'package:todo_with_api/screens/add_page.dart';
import 'package:todo_with_api/services/todo_service.dart';
import 'package:todo_with_api/utils/snackbar_helper.dart';
import 'package:todo_with_api/widget/todo_card.dart';

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
          child: Visibility(
            visible: toDoItems.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item found',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
            child: ListView.builder(
              itemCount: toDoItems.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = toDoItems[index] as Map;
                return TodoCard(
                  index: index,
                  item: item,
                  navigateToEditTodoPage: navigateToEditTodoPage,
                  deleteTodoById: deleteTodoById,
                );
              },
            ),
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
    final response = await TodoService.fetchTodoData();

    if (response != []) {
      setState(() {
        toDoItems = response;
      });
    } else {
      showErrorMessage(context, message: 'Failed to fetch todo data');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTodoById(String todoId) async {
    //delete the todo item
    final isSuccess = await TodoService.deleteTodoById(todoId);

    if (isSuccess) {
      //remove the todo item from the list
      final filterdItems =
          toDoItems.where((element) => element['_id'] != todoId).toList();
      setState(() {
        toDoItems = filterdItems;
      });
      fetchTodoData();
    } else {
      //show error message
      showErrorMessage(context, message: 'Failed to delete todo item');
    }
  }
}
