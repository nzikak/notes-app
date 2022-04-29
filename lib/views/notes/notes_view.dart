import 'package:flutter/material.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/local/note_entity.dart';
import 'package:notes_app/services/local/notes_service.dart';
import 'package:notes_app/utils/sign_out_user.dart';
import '../../enums/menu_action.dart';

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
              _navigateToNewNoteView(context);
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
                  final shouldLogout = await _showLogoutDialog(context);
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
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                final note = notes[index];
                                return ListTile(
                                  title: Text(
                                    note.content,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                if (index != notes.length - 1) {
                                  return const Divider(thickness: 1);
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                              itemCount: notes.length);
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

  Future<bool> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Sign Out"),
              content: const Text("Are you sure you want to sign out?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes"))
              ]);
        }).then((value) => value ?? false);
  }

  void _navigateToNewNoteView(BuildContext context) {
    Navigator.of(context).pushNamed(newNotesRoute);
  }
}
