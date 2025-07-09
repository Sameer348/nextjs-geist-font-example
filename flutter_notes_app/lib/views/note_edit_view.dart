import 'package:flutter/material.dart';
import 'package:flutter_notes_app/models/note.dart';
import 'package:flutter_notes_app/viewmodels/note_viewmodel.dart';
import 'package:provider/provider.dart';

class NoteEditView extends StatefulWidget {
  final Note? note;

  const NoteEditView({Key? key, this.note}) : super(key: key);

  @override
  _NoteEditViewState createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late Color _color;
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _description = widget.note?.description ?? '';
    _color = widget.note?.color ?? Colors.white;
    _isPinned = widget.note?.isPinned ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = Provider.of<NoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                if (widget.note?.id != null) {
                  noteVM.deleteNote(widget.note!.id!);
                }
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
                onSaved: (value) => _title = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  expands: true,
                  onSaved: (value) => _description = value ?? '',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Pin note'),
                  Switch(
                    value: _isPinned,
                    onChanged: (value) {
                      setState(() {
                        _isPinned = value;
                      });
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        final now = DateTime.now();
                        final note = Note(
                          id: widget.note?.id,
                          title: _title,
                          description: _description,
                          createdAt: widget.note?.createdAt ?? now,
                          updatedAt: now,
                          isPinned: _isPinned,
                          color: _color,
                        );
                        if (widget.note == null) {
                          noteVM.addNote(note);
                        } else {
                          noteVM.updateNote(note);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
