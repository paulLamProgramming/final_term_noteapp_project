import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:final_noteapp_new/constants/db_contants.dart';
import 'package:final_noteapp_new/models/note_model.dart';
import 'package:flutter/foundation.dart';

class NoteListState extends Equatable {
  final bool loading;
  final List<Note> notes;

  NoteListState({
    required this.loading,
    required this.notes,
  });

  NoteListState copyWith({
    required bool loading,
    required List<Note> notes,
  }) {
    return NoteListState(
      loading: loading,
      notes: notes,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [loading, notes];
}

class NoteList extends ChangeNotifier {
  NoteListState state = NoteListState(loading: false, notes: []);
  final int pageSize = 10;
  bool hasNext = true;

  void handleError(Exception e) {
    print(e);
    state = state.copyWith(loading: false, notes: []);
    notifyListeners();
  }

  Future<void> getNotes(String userId, int limit) async {
    state = state.copyWith(loading: true, notes: []);
    notifyListeners();

    try {
      QuerySnapshot userNotesSnapshot;
      DocumentSnapshot? startAfter;

      if (state.notes.isNotEmpty) {
        Note n = state.notes.last;
        startAfter =
        await notesRef.doc(userId).collection('userNotes').doc(n.id).get();
      } else {
        startAfter = null;
      }

      final refNotes = notesRef
          .doc(userId)
          .collection('userNotes')
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startAfter == null) {
        userNotesSnapshot = await refNotes.get();
      } else {
        userNotesSnapshot = await refNotes.startAfterDocument(startAfter).get();
      }

      List<Note> notes = userNotesSnapshot.docs.map((noteDoc) {
        return Note.fromDoc(noteDoc);
      }).toList();

      if (userNotesSnapshot.docs.length < pageSize) {
        hasNext = false;
      }

      state = state.copyWith(
        loading: false,
        notes: [...state.notes, ...notes],
      );
      notifyListeners();
    } catch (e) {
      handleError(Exception(e));
      rethrow;
    }
  }

  Future<void> getAllNotes(String userId) async {
    state = state.copyWith(loading: true, notes: []);
    notifyListeners();

    try {
      QuerySnapshot userNotesSnapshot = await notesRef
          .doc(userId)
          .collection('userNotes')
          .orderBy('timestamp', descending: true)
          .get();

      List<Note> notes = userNotesSnapshot.docs.map((noteDoc) {
        return Note.fromDoc(noteDoc);
      }).toList();

      state = state.copyWith(loading: false, notes: notes);
      notifyListeners();
    } catch (e) {
      handleError(Exception(e));
      rethrow;
    }
  }
}