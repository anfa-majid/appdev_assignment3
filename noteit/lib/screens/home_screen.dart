import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc.dart';
import '../blocs/state.dart';
import '../widgets/note_card.dart';
import '../widgets/category.dart';
import 'add_note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F4FF),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "NoteIt",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 40,
              width: 100,
              child: Category(),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          final notes = state.filteredNotes;
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "No notes available",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
            child: GridView.builder(
              itemCount: notes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (ctx, idx) {
                return Transform.rotate(
                  angle: -0.052, // ~-3 degrees
                  child: NoteCard(note: notes[idx]),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNoteScreen()),
          );
        },
        backgroundColor: Colors.pink.shade200,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
