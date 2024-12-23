import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class Note {
  String title;
  String content;
  DateTime dateCreated;
  String category;
  String priority;
  bool isCompleted;
  Color color;

  Note({
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    required this.color,
  });
}

class _NoteHomeState extends State<NoteHome> {
  final List<Note> _notes = [];
  String _selectedFilter = 'All';
  final List<String> _categories = ['All', 'Home', 'Work', 'Personal'];
  final List<String> _priorities = ['All', 'Low', 'Medium', 'High'];

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Home':
        return Colors.orange;
      case 'Work':
        return Colors.blue;
      case 'Personal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Home';
    String selectedPriority = 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .where((category) => category != 'All')
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value!;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: _priorities.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPriority = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _notes.add(Note(
                      title: titleController.text,
                      content: contentController.text,
                      dateCreated: DateTime.now(),
                      category: selectedCategory,
                      priority: selectedPriority,
                      color: _getCategoryColor(selectedCategory),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _selectedFilter == 'All'
        ? _notes
        : _selectedFilter.contains('Low') || _selectedFilter.contains('Medium') || _selectedFilter.contains('High')
            ? _notes.where((note) => note.priority == _selectedFilter).toList()
            : _notes.where((note) => note.category == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ..._categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedFilter == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = category;
                        });
                      },
                    ),
                  );
                }).toList(),
                ..._priorities.map((priority) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(priority),
                      selected: _selectedFilter == priority,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = priority;
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          "You don't have any notes",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Card(
                        color: note.color.withOpacity(0.2),
                        child: ListTile(
                          leading: Checkbox(
                            value: note.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                note.isCompleted = value!;
                              });
                            },
                          ),
                          title: Text(
                            note.title,
                            style: TextStyle(
                              decoration: note.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.content,
                                style: TextStyle(
                                  decoration: note.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(note.dateCreated),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Implement edit functionality
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _notes.remove(note);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
