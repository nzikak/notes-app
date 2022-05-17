import 'package:flutter/material.dart';
import 'package:notes_app/extensions/generics/get_arguments.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/cloud/cloud_note_entity.dart';
import 'package:notes_app/services/cloud/cloud_storage_service.dart';
import 'package:notes_app/services/local/local_note_entity.dart';
import 'package:notes_app/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:notes_app/extensions/build_context/localization.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _noteController;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
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
      documentId: note.documentId,
      content: content,
    );
  }

  void _setUpNoteControllerListener() {
    _noteController.removeListener(_noteControllerListener);
    _noteController.addListener(_noteControllerListener);
  }

  Future<CloudNote> _createOrGetExistingNote(BuildContext context) async {
    final noteArg = context.getArguments<CloudNote>();
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

    final newNote =
        await _noteService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_noteController.text.isEmpty && note != null) {
      _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final content = _noteController.text;

    if (note != null && content.isNotEmpty) {
      await _noteService.updateNote(
        documentId: note.documentId,
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
        actions: [
          IconButton(
            onPressed: () async {
              final text = _noteController.text;
              if(_note == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
                return;
              }
              Share.share(text);
            },
            icon: const Icon(Icons.share),
          )
        ],
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
                  decoration: InputDecoration(
                      hintText: context.loc.start_typing_your_note,
                      border: const OutlineInputBorder()),
                ),
              );
            default:
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}
