import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/cloud/cloud_note_entity.dart';
import 'package:notes_app/services/cloud/cloud_storage_service.dart';
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
  String get _userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _noteService;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    // _noteService.openDb();
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
                    context.read<AuthBloc>()
                        .add(const AuthEventLogOut());
                  }
                  break;
              }
            },
          )
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: _userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final notes = snapshot.data as Iterable<CloudNote>;
                return NoteListView(
                  notes: notes,
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onNavigateToCreateUpdateNote: (note) {
                    _navigateToCreateUpdateNoteView(
                      context,
                      note: note,
                    );
                  },
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }
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

  void _navigateToCreateUpdateNoteView(BuildContext context,
      {CloudNote? note}) {
    Navigator.of(context).pushNamed(
      createUpdateNoteRoute,
      arguments: note,
    );
  }
}
