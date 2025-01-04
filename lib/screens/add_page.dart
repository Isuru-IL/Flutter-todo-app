import 'package:flutter/material.dart';
import 'package:todo_with_api/services/todo_service.dart';
import 'package:todo_with_api/utils/snackbar_helper.dart';

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
      showErrorMessage(context, message: 'Failed to update todo');
      return;
    }

    final todoId = todoItem['_id'];
    // final isCompleted = todoItem['is_completed'];

    // Send the data to the server
    final isSuccess = await TodoService.updateTodoData(todoId, todoBody);

    // show success or error message based on status
    if (isSuccess) {
      showSuccesMessage(context, message: 'Todo updated successfully');
    } else {
      showErrorMessage(context, message: 'Failed to update todo');
    }
  }

  Future<void> submitTodoData() async {
    // Get the title and description from the text fields
    final todoDataBody = todoBody;
    // Send the data to the server
    final isSuccess = await TodoService.submitTodoData(todoDataBody);
    // show success or error message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSuccesMessage(context, message: 'Todo added successfully');
    } else {
      showErrorMessage(context, message: 'Failed to add todo');
    }
  }

  Map get todoBody {
    //get the title and description from the text fields
    final title = titleController.text;
    final description = descriptionController.text;
    final todoDataBody = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    return todoDataBody;
  }
}
