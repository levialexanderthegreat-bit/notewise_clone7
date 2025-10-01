import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => NotesModel()..loadNotes(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notewise Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesPage(),
    );
  }
}

class NotesModel extends ChangeNotifier {
  List<String> notes = [];
  SharedPreferences? prefs;

  Future<void> loadNotes() async {
    prefs = await SharedPreferences.getInstance();
    notes = prefs?.getStringList("notes") ?? [];
    notifyListeners();
  }

  void add(String note) {
    notes.add(note);
    prefs?.setStringList("notes", notes);
    notifyListeners();
  }

  void delete(int index) {
    notes.removeAt(index);
    prefs?.setStringList("notes", notes);
    notifyListeners();
  }
}

class NotesPage extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var model = context.watch<NotesModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Notewise Clone")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: controller, decoration: InputDecoration(hintText: "Write a note...")),
          ),
          ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  model.add(controller.text);
                  controller.clear();
                }
              },
              child: Text("Add Note")),
          Expanded(
            child: ListView.builder(
              itemCount: model.notes.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(model.notes[i]),
                trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => model.delete(i)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
