import 'package:flutter/material.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/services/note_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteViewModel extends ChangeNotifier {
  List<Note> _notes = [];
  bool _isDarkMode = false;

  List<Note> get notes => _notes;
  bool get isDarkMode => _isDarkMode;

  NoteViewModel() {
    _loadNotes();
    _loadTheme();
  }

  Future<void> _loadNotes() async {
    _notes = await NoteDatabase.instance.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await NoteDatabase.instance.insertNote(note);
    await _loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await NoteDatabase.instance.updateNote(note);
    await _loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await NoteDatabase.instance.deleteNote(id);
    await _loadNotes();
  }

  void togglePin(Note note) {
    note.isPinned = !note.isPinned;
    updateNote(note);
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }
}
