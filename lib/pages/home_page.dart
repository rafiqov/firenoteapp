
import 'package:firenoteapp/pages/sign_in_page.dart';
import 'package:firenoteapp/pages/sign_up_page.dart';
import 'package:firenoteapp/services/auth_service.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:flutter/material.dart';
import '../models/note_models.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Note> notes = [];

  void _openSignIn() {
    HiveDB.removeUser();
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void showSnackBar({required String text}) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void getData() async {
    setState(() => isLoading = true);
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    setState(() => isLoading = false);
  }

  void _openSignUp() => Navigator.pushReplacementNamed(context, SignUpPage.id);

  void _openDetailPage() async {
    var res = await Navigator.pushNamed(context, DetailPage.id);
    if (res as bool) {
      setState(() => isLoading = true);
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      setState(() => isLoading = false);
    }
  }

  void removeNote(Note note) async {
    setState(() => isLoading = true);
    await RealTimeDataBase.deletePost(note);
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    setState(() => isLoading = false);
  }

  void _openDetailForEdit(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));
    if (result != null && result == true) {
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      setState(() => isLoading = false);
    }
  }

  void changeMode() => setState(() => HiveDB.storeMode(!HiveDB.loadMode()));

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.red))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return itemWidget(notes[index]);
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        "Home",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        // #language_picker
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: DropdownButton<String>(
            alignment: Alignment.centerRight,
            underline: Container(),
            isDense: true,
            value: 'Menu',
            items: <String>[
              'Menu',
              'Log Out',
              'Delete',
              'Add',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)),
              );
            }).toList(),
            onChanged: (String? value) async {
              if (value == 'Log Out') {
                _openSignIn();
              } else if (value == 'Delete') {
                AuthService.removeUser(context);
                showSnackBar(text: "Remove user");
              } else if (value == 'Add') {
                showSnackBar(text: "Add user");
                _openSignUp();
              }
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        MaterialButton(
          onPressed: changeMode,
          child: Icon(HiveDB.loadMode() ? Icons.dark_mode : Icons.light_mode),
        )
      ],
    );
  }

  Widget itemWidget(Note note) {
    return ListTile(
      onTap: () => _openDetailForEdit(note),
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: IconButton(
        onPressed: () => removeNote(note),
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }
}
