import '../model/note.dart';

class NoteState {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final NoteCategory? selectedCategory;

  NoteState({
    required this.notes,
    required this.filteredNotes,
    this.selectedCategory,
  });

  NoteState copyWith({
    List<Note>? notes,
    List<Note>? filteredNotes,
    NoteCategory? selectedCategory,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
