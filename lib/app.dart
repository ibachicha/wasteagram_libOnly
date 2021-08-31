import 'package:flutter/material.dart';
import 'package:wasteagram/screens/entry_lists.dart';
import 'screens/new_post.dart';
import 'screens/details_page.dart';

class MyApp extends StatelessWidget {
  final String title;

  const MyApp({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Scaffold(body: EntryLists()),
        'newPost': (context) => const NewPost(),
        'rowDetails': (context) => const RowDetail(),
      },
    );
  }
}
