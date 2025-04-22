import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/bloc.dart';
import '../blocs/event.dart';
import '../blocs/state.dart';
import '../model/note.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  String displayCategoryText(NoteCategory? category) {
    if (category == null) return 'All';
    switch (category) {
      case NoteCategory.Work:
        return 'Work';
      case NoteCategory.Personal:
        return 'Personal';
      case NoteCategory.Study:
        return 'Study';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final categories = <NoteCategory?>[null, ...NoteCategory.values];
        final selected = state.selectedCategory;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<NoteCategory?>(
              isExpanded: true,
              value: selected,
              onChanged: (value) {
                context.read<NoteBloc>().add(FilterNotesByCategory(value));
              },
              items: categories.map((cat) {
                return DropdownMenuItem<NoteCategory?>(
                  value: cat,
                  child: Text(displayCategoryText(cat)),
                );
              }).toList(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              borderRadius: BorderRadius.circular(12),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }
}
