import 'dart:convert';

import 'package:http/http.dart' as http;

//All todo api call will be done in this file

class TodoService {
  static Future<bool> deleteTodoById(String todoId) async {
    //delete the todo item
    final url = 'https://api.nstack.in/v1/todos/$todoId';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

  static Future<List> fetchTodoData() async {
    // Fetch the data from the server
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      //items kiyl danne data enne 'items' kiyl list eke

      return result;
    } else {
      return [];
    }
  }

  static Future<bool> updateTodoData(String todoId, Map todoDataBody) async {
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

    return response.statusCode == 200;
  }

  static Future<bool> submitTodoData(Map todoDataBody) async {
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

    return response.statusCode == 201;
  }
}
