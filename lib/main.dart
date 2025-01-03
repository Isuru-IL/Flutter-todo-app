import 'package:flutter/material.dart';
import 'package:todo_with_api/screens/todo_list_page.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: TodoListPage(),
    );
  }
}
