import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/local/note_entity.dart';
import 'package:notes_app/services/local/notes_service.dart';
import 'package:notes_app/utils/sign_out_user.dart';
import 'package:notes_app/views/notes/notes_list_view.dart';
import '../../enums/menu_action.dart';
import '../../utils/dialogs/sign_out_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get _userEmail => AuthService.firebase().currentUser!.email!;
  late final NoteService _noteService;

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.openDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _navigateToCreateUpdateNoteView(context);
            },
            icon: const Icon(Icons.add_circle),
          ),
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: MenuAction.logout, child: Text("Sign out"))
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    signOutUser(context, loginRoute);
                  }
                  break;
              }
            },
          )
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _noteService.getOrCreateUser(email: _userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _noteService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final notes = snapshot.data as List<Note>;
                          return NoteListView(
                            notes: notes,
                            onDeleteNote: (note) async {
                              await _noteService.deleteNote(noteId: note.id!);
                            },
                            onNavigateToCreateUpdateNote: (note) {
                              _navigateToCreateUpdateNoteView(
                                context,
                                note: note,
                              );
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }

  void _navigateToCreateUpdateNoteView(BuildContext context, {Note? note}) {
    Navigator.of(context).pushNamed(
      createUpdateNoteRoute,
      arguments: note,
    );
  }
}
