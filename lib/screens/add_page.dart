import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todoItem;

  const AddTodoPage({super.key, this.todoItem});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    final todoItem = widget.todoItem;
    if (todoItem != null) {
      isEditMode = true; //todoItem null nemei nn eka edit mode ekak
      final title = todoItem['title'];
      final description = todoItem['description'];

      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEditMode ? updateTodoData : submitTodoData,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(isEditMode ? 'Update' : 'Submit'),
              )),
        ],
      ),
    );
  }

  Future<void> updateTodoData() async {
    // Get the title and description from the text fields
    final todoItem = widget.todoItem;
    if (todoItem == null) {
      showErrorMessage('you can not call updated without todo data');
      return;
    }

    final todoId = todoItem['_id'];
    final isCompleted = todoItem['is_completed'];

    final title = titleController.text;
    final description = descriptionController.text;
    final todoDataBody = {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
    };

    // Send the data to the server
    final url = 'https://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(todoDataBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // show success or error message based on status
    if (response.statusCode == 200) {
      showSuccesMessage('Todo updated successfully');
    } else {
      showErrorMessage('Failed to update todo');
    }
  }

  Future<void> submitTodoData() async {
    // Get the title and description from the text fields
    final title = titleController.text;
    final description = descriptionController.text;
    final todoDataBody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // Send the data to the server
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(todoDataBody),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // show success or error message based on status
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';

      showSuccesMessage('Todo added successfully');
    } else {
      showErrorMessage('Failed to add todo');
    }
  }

  void showSuccesMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
