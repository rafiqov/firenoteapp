import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:flutter/material.dart';
import '../models/note_models.dart';
import '../services/hive_service.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";

  // for edit
  final Note? note;

  const DetailPage({Key? key, this.note}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _storeNote() async {
    if (widget.note == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty) {
        String userId = HiveDB.loadUser();
        Note note = Note(title: title, content: content, userId: userId);
        RealTimeDataBase.addPost(note);
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty) {
        Note note = Note(
            title: title,
            content: content,
            userId: widget.note?.userId,
            key: widget.note?.key);

        RealTimeDataBase.updatePost(note);
      }
    }
    Navigator.pop(context, true);
  }

  void loadNote(Note? note) {
    if (note != null) {
      setState(() {
        titleController.text = note.title;
        contentController.text = note.content;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _storeNote();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: _storeNote,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // #title
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: "Title",
                ),
                cursorColor: Colors.orange,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),

            // #content
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: TextField(
                controller: contentController,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                cursorColor: Colors.orange,
                showCursor: true,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
