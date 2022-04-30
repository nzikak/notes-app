import 'package:flutter/material.dart';
import 'package:notes_app/services/local/note_entity.dart';

import '../../utils/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(Note note);

class NoteListView extends StatelessWidget {
  final List<Note> notes;
  final DeleteNoteCallback onDeleteNote;

  const NoteListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete_rounded),
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
  }
}
