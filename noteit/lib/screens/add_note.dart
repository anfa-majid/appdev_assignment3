import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../blocs/bloc.dart';
import '../blocs/event.dart';
import '../model/note.dart';
import '../widgets/image.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  NoteCategory _category = NoteCategory.Work;
  List<XFile> _pickedImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _category = widget.note!.category;
      _pickedImages = widget.note!.imagePaths.map((p) => XFile(p)).toList();
    }
  }

  Future<void> _pickImages() async {
    final result = await ImagePicker().pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        for (var f in result) {
          if (!_pickedImages.any((e) => e.path == f.path)) {
            _pickedImages.add(f);
          }
        }
      });
    }
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and content cannot be empty")),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id ?? const Uuid().v4(),
      title: title,
      content: content,
      category: _category,
      isPinned: widget.note?.isPinned ?? false,
      imagePaths: _pickedImages.map((x) => x.path).toList(),
    );

    final bloc = context.read<NoteBloc>();
    widget.note == null ? bloc.add(AddNote(note)) : bloc.add(UpdateNote(note));
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
        leading: const BackButton(color: Colors.black),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Title
            TextField(
              controller: _titleController,
              decoration: _inputDecoration("Title"),
            ),
            const SizedBox(height: 14),

            /// Content
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: _inputDecoration("Content"),
            ),
            const SizedBox(height: 14),

            InputDecorator(
              decoration: _inputDecoration("Category"),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<NoteCategory>(
                  value: _category,
                  isExpanded: true,
                  items: NoteCategory.values.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c.name),
                    );
                  }).toList(),
                  onChanged: (c) => setState(() => _category = c!),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ImageWidget(
              images: _pickedImages,
              onAdd: _pickImages,
              onRemove: (i) => setState(() => _pickedImages.removeAt(i)),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(widget.note == null ? "Save" : "Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
