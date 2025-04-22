import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../model/note.dart';
import 'event.dart';
import 'state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final Box<Note> noteBox = Hive.box<Note>('notes');

  NoteBloc()
      : super(NoteState(
          notes: [],
          filteredNotes: [],
        )) {
    on<LoadNotes>((event, emit) {
      final notes = noteBox.values.toList();
      final currentCategory = state.selectedCategory;

      final filtered = currentCategory == null
          ? notes
          : notes.where((n) => n.category == currentCategory).toList();
      filtered.sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

      emit(state.copyWith(
        notes: notes,
        filteredNotes: filtered,
      ));
    });

    on<AddNote>((event, emit) {
      noteBox.put(event.note.id, event.note);
      add(LoadNotes());
    });

    on<DeleteNote>((event, emit) {
      noteBox.delete(event.id);
      add(LoadNotes());
    });

    on<UpdateNote>((event, emit) {
      noteBox.put(event.note.id, event.note);
      add(LoadNotes());
    });

    on<FilterNotesByCategory>((event, emit) {
      final newCategory = event.category;

      final filtered = newCategory == null
          ? state.notes
          : state.notes.where((n) => n.category == newCategory).toList();
      filtered.sort((a, b) => (b.isPinned ? 1 : 0).compareTo(a.isPinned ? 1 : 0));

      emit(state.copyWith(
        selectedCategory: newCategory,
        filteredNotes: filtered,
      ));
    });
  }
}
