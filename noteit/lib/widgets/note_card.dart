import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/note.dart';
import '../screens/add_note.dart';
import '../screens/note_detail.dart'; 
import '../blocs/bloc.dart';
import '../blocs/event.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  Color _colorForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'work':
        return Colors.yellow.shade100;
      case 'personal':
        return Colors.blue.shade100;
      case 'study':
        return Colors.pink.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _colorForCategory(note.categoryText);
    return InkWell(
      onTap: () => showNoteDetailSheet(context, note),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (note.isPinned)
                  const Icon(Icons.push_pin, size: 16),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CategoryChip(label: note.categoryText, color: bgColor),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (note.imagePaths.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.attach_file, size: 18),
                      ),
                    InkWell(
                      onTap: () {
                        final updatedNote = Note(
                          id: note.id,
                          title: note.title,
                          content: note.content,
                          category: note.category,
                          isPinned: !note.isPinned,
                          imagePaths: note.imagePaths,
                        );
                        context.read<NoteBloc>().add(UpdateNote(updatedNote));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.push_pin_outlined, size: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddNoteScreen(note: note),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.edit, size: 18),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Note?"),
                            content: const Text("Are you sure you want to delete this note?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<NoteBloc>().add(DeleteNote(note.id));
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.delete, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _CategoryChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
