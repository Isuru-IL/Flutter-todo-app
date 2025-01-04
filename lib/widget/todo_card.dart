import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateToEditTodoPage;
  final Function(String) deleteTodoById;

  const TodoCard(
      {super.key,
      required this.index,
      required this.item,
      required this.navigateToEditTodoPage,
      required this.deleteTodoById});

  @override
  Widget build(BuildContext context) {
    final todoId = item['_id'] as String; // todo id eka gannawa
    return Card(
      child: ListTile(
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
      ),
    );
  }
}
