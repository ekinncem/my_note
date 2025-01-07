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
    final isTablet = screenSize.width > 600;
    final filteredNotes = _selectedFilter == 'All'
        ? _notes
        : _selectedFilter.contains('Low') ||
                _selectedFilter.contains('Medium') ||
                _selectedFilter.contains('High')
            ? _notes.where((note) => note.priority == _selectedFilter).toList()
            : _notes.where((note) => note.category == _selectedFilter).toList();

    Widget buildNoteCard(Note note) {
      return Card(
        elevation: 4,
        color: note.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Implement note details view
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
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
                      size: 20,
                    ),
                    Checkbox(
                      value: note.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          note.isCompleted = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      decoration: note.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
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
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          iconSize: 20,
                          onPressed: () => _editNoteDialog(note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          iconSize: 20,
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
      );
    }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              : isTablet
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredNotes.length,
                      itemBuilder: (context, index) => buildNoteCard(filteredNotes[index]),
                    )
                  : ListView.separated(
                      itemCount: filteredNotes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => buildNoteCard(filteredNotes[index]),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
