import 'package:flutter/material.dart';
import 'package:fristapp/services/auth/auth_services.dart';
import 'package:fristapp/services/cloud/Cloud_note.dart';
import 'package:fristapp/services/cloud/firebase_cloud_stroage.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNotViewState();
}

class _NewNotViewState extends State<NewNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesServices;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    _textEditingController = TextEditingController();

    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesServices.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListerner() {
    _textEditingController.removeListener((_textControllerListener));
    _textEditingController.addListener(_textControllerListener);
  }

  Future<CloudNote> createNewNote() async {
//    final WidgetNote = context.getArgument<DatabaseNotes>();

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    return await _notesServices.createNewNote(ownerUserId: userId);
  }

  void deletNoteIfIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesServices.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesServices.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    deletNoteIfIsEmpty();
    _saveNoteIfNotEmpty();
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
      ),
      body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as CloudNote?;
                _setupTextControllerListerner();
                return TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Start Typing a notes',
                    ));
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
