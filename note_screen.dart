import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String _tog = "en";
  List<Map<String, dynamic>> notes = [];
  late SharedPreferences prefs;

  final List<Color> colors = [
    Color(0xFF00C3A5),
    Color(0xFFFFC107),
    Color(0xFF0D1B49),
    Colors.deepPurple,
    Colors.teal,
    Colors.indigo
  ];

  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    prefs = await SharedPreferences.getInstance();
    List<String>? savedNotes = prefs.getStringList('notes');
    if (savedNotes != null) {
      setState(() {
        notes = savedNotes
            .map((note) => jsonDecode(note))
            .toList()
            .cast<Map<String, dynamic>>();
      });
    }

    setState(() {
      _tog = prefs.getString("tog") ?? "en";
      context.setLocale(Locale(_tog));
    });
  }

  Future<void> _saveNotes() async {
    List<String> encodedNotes = notes.map((note) => jsonEncode(note)).toList();
    await prefs.setStringList('notes', encodedNotes);
  }

  void _addNewNote(String title, String content) {
    Map<String, dynamic> newNote = {
      'time': TimeOfDay.now().format(context),
      'title': title,
      'content': content,
      'color': colors[colorIndex % colors.length].value,
    };

    setState(() {
      notes.add(newNote);
      colorIndex++;
    });

    _saveNotes();
  }

  Future<void> _toggleTheme() async {
    if (_tog == "en") {
      context.setLocale(Locale("ar"));
      _tog = "ar";
    } else {
      context.setLocale(Locale("en"));
      _tog = "en";
    }
    await prefs.setString("tog", _tog);
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
    _saveNotes();
  }

  void _showAddNoteDialog() {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF041C50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text("add note".tr(), style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "title".tr(),
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "content".tr(),
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("cancel".tr(), style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                String title = titleController.text.trim();
                String content = contentController.text.trim();
                if (title.isNotEmpty && content.isNotEmpty) {
                  _addNewNote(title, content);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: Text("add".tr()),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF041C50),
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: _toggleTheme,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text(_tog == "en" ? "عربي" : "EN"),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Notes".tr(), style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _showAddNoteDialog,
            child: Text(
              "+ Add New".tr(),
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(notes.length, (index) {
                  final note = notes[index];
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.44,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color(note['color']),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(note['time'],
                                style: TextStyle(color: Colors.white, fontSize: 13)),
                            SizedBox(height: 6),
                            Text(note['title'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text(note['content'],
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white, height: 1.4)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deleteNote(index),
                        ),
                      )
                    ],
                  );
                }),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0D1B49),
        onPressed: _showAddNoteDialog,
        child: Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF041C50),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: ""),
        ],
      ),
    );
  }
}
