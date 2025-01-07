// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'note_models.dart';

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

  Color _getRandomColor() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final colors = [
      Colors.blue.withOpacity(0.2),
      Colors.green.withOpacity(0.2),
      Colors.purple.withOpacity(0.2),
      Colors.orange.withOpacity(0.2),
      Colors.pink.withOpacity(0.2),
      Colors.teal.withOpacity(0.2),
      Colors.indigo.withOpacity(0.2),
      Colors.cyan.withOpacity(0.2),
    ];
    return colors[random % colors.length];
  }

  void _showNoteDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String selectedCategory = 'Home';
    String selectedPriority = 'Low';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Note',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.note),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category),
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
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.priority_high),
                    ),
                    items: _priorities
                        .where((priority) => priority != 'All')
                        .map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedPriority = value!;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Create Note'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            setState(() {
                              _notes.add(Note(
                                title: titleController.text,
                                content: contentController.text,
                                dateCreated: DateTime.now(),
                                category: selectedCategory,
                                priority: selectedPriority,
                                color: _getRandomColor(),
                              ));
                              print('Note added: ${titleController.text}');
                              print('Total notes: ${_notes.length}');
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filter Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Categories'),
              Wrap(
                spacing: 8,
                children: _categories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: _selectedFilter == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = category;
                      });
                      Navigator.pop(context);
                    },
                    avatar: Icon(
                      category == 'Home'
                          ? Icons.home
                          : category == 'Work'
                              ? Icons.work
                              : category == 'Personal'
                                  ? Icons.person
                                  : Icons.all_inbox,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Priorities'),
              Wrap(
                spacing: 8,
                children: _priorities.map((priority) {
                  return FilterChip(
                    label: Text(priority),
                    selected: _selectedFilter == priority,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = priority;
                      });
                      Navigator.pop(context);
                    },
                    avatar: Icon(
                      priority == 'High'
                          ? Icons.warning
                          : priority == 'Medium'
                              ? Icons.priority_high
                              : priority == 'Low'
                                  ? Icons.low_priority
                                  : Icons.all_inbox,
                      color: priority == 'High'
                          ? Colors.red
                          : priority == 'Medium'
                              ? Colors.orange
                              : priority == 'Low'
                                  ? Colors.green
                                  : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
                      child: Row(
                        children: filteredNotes.map((note) {
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
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateNoteForm extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create New Note',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextField(
            controller: contentController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.note),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: () {
              // Handle save note action
            },
            child: Text('Save Note'),
          ),
        ],
      ),
    );
  }
}
