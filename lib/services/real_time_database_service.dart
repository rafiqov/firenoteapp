import 'package:firebase_database/firebase_database.dart';

import '../models/note_models.dart';

class RealTimeDataBase {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Note note) async {
    _database.child("posts").push().set(note.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Note>> getPosts(String id) async {
    Query _query = _database.child("posts").orderByChild("userId").equalTo(id);
    var snapshot = await _query.once();
    var result = snapshot.snapshot.children;
    List<Note> items = result.map((item) {
      var note = Map<String, dynamic>.from(item.value as Map);
      note['key'] = item.key;
      return Note.fromJson(note);
    }).toList();
    return items;
  }

  static Future<void> updatePost(Note note) async {
    final Map<String, Map> updates = {};
    updates['/posts/${note.key}'] = note.toJson();

    return await _database.update(updates);
  }

  static Future<void> deletePost(Note note) async {
    return await _database.child('posts').child(note.key.toString()).remove();
  }
}
