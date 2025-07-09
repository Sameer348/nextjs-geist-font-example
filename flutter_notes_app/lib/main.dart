import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_notes_app/viewmodels/note_viewmodel.dart';
import 'package:flutter_notes_app/views/home_view.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteViewModel(),
      child: Consumer<NoteViewModel>(
        builder: (context, noteVM, child) {
          return MaterialApp(
            title: 'Flutter Notes App',
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blueAccent,
                secondary: Colors.blueAccent,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.blueAccent,
                secondary: Colors.blueAccent,
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.blueAccent,
              ),
            ),
            themeMode: noteVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}
