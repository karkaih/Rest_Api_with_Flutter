import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rest_api/services/note_service.dart';
import 'package:rest_api/views/not_liste.dart';
void setupLocator (){
  GetIt.I.registerLazySingleton(() => NotesService());

}
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
