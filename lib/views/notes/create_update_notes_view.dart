import 'package:flutter/material.dart';
import 'package:notes_app/extensions/generics/get_arguments.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/local/local_note_entity.dart';
import 'package:notes_app/services/local/notes_service.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  LocalNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _noteController;

  @override
  void initState() {
    _noteService = NoteService();
    _noteController = TextEditingController();
    super.initState();
  }

  void _noteControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final content = _noteController.text;
    await _noteService.updateNote(
      note: note,
      content: content,
    );
  }

  void _setUpNoteControllerListener() {
    _noteController.removeListener(_noteControllerListener);
    _noteController.addListener(_noteControllerListener);
  }

  Future<LocalNote> _createOrGetExistingNote(BuildContext context) async {
    final noteArg = context.getArguments<LocalNote>();
    if (noteArg != null) {
      _note = noteArg;
      _noteController.text = noteArg.content;
      return noteArg;
    }

    final currentNote = _note;
    if (currentNote != null) {
      return currentNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final noteOwner = await _noteService.getUser(email: currentUser.email);

    final newNote = await _noteService.createNote(owner: noteOwner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_noteController.text.isEmpty && note != null) {
      _noteService.deleteNote(noteId: note.id!);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final content = _noteController.text;

    if (note != null && content.isNotEmpty) {
      await _noteService.updateNote(
        note: note,
        content: content,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteArg = context.getArguments<LocalNote>();
    return Scaffold(
      appBar: AppBar(
        title: Text((noteArg == null) ? "New Note" : "Update Note"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpNoteControllerListener();
              return Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _noteController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      hintText: "Enter your note here...",
                      border: OutlineInputBorder()),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
