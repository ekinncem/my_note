// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note_models.dart';
import 'note_dialog.dart';
import 'filter_menu.dart';

void main() {
  runApp(const MyNoteApp());
}

class MyNoteApp extends StatelessWidget {
  const MyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Note',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.cyan,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NoteHome(),
    );
  }
}

class NoteHome extends StatefulWidget {
  const NoteHome({super.key});

  @override
  _NoteHomeState createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  final List<Note> _notes = [];
  String _selectedFilter = 'All';
  final List<String> _categories = ['All', 'Home', 'Work', 'Personal'];
  final List<String> _priorities = ['All', 'Low', 'Medium', 'High'];

  void _showNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onSave: (title, content, category, priority, color) {
            setState(() {
              _notes.add(Note(
                title: title,
                content: content,
                dateCreated: DateTime.now(),
                category: category,
                priority: priority,
                color: color,
              ));
            });
          },
        );
      },
    );
  }

  void _editNoteDialog(Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  note.title = titleController.text;
                  note.content = contentController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openFilterMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilterMenu(
          categories: _categories,
          priorities: _priorities,
          selectedFilter: _selectedFilter,
          onFilterSelected: (filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final filteredNotes = _selectedFilter == 'All'
        ? _notes
        : _selectedFilter.contains('Low') ||
                _selectedFilter.contains('Medium') ||
                _selectedFilter.contains('High')
            ? _notes.where((note) => note.priority == _selectedFilter).toList()
            : _notes.where((note) => note.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterMenu,
          ),
        ],
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: screenSize.height * 0.02),
        child: Column(
          children: [
            Expanded(
              child: _notes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.note_add,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "You don't have any notes",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Create Your First Note'),
                            onPressed: _showNoteDialog,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: filteredNotes.map((note) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 4,
                                color: note.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Implement note details view
                                  },
                                  child: Container(
                                    width: screenSize.width * 0.3,
                                    height: screenSize.width * 0.3, // Make the note square
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              note.priority == 'High'
                                                  ? Icons.warning
                                                  : note.priority == 'Medium'
                                                      ? Icons.priority_high
                                                      : Icons.low_priority,
                                              color: note.priority == 'High'
                                                  ? Colors.red
                                                  : note.priority == 'Medium'
                                                      ? Colors.orange
                                                      : Colors.green,
                                              size: 16,
                                            ),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: Checkbox(
                                                value: note.isCompleted,
                                                onChanged: (value) {
                                                  setState(() {
                                                    note.isCompleted = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          note.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: note.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Expanded(
                                          child: Text(
                                            note.content,
                                            style: TextStyle(
                                              fontSize: 14,
                                              decoration: note.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('MMM dd').format(note.dateCreated),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  iconSize: 16,
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () {
                                                    _editNoteDialog(note);
                                                  },
                                                ),
                                                const SizedBox(width: 4),
                                                IconButton(
                                                  iconSize: 16,
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  icon: const Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      _notes.remove(note);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
