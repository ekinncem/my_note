import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        colorScheme: ColorScheme.dark(primary: Colors.cyan),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const NoteHome(),
    );
  }
}

class NoteHome extends StatefulWidget {
  const NoteHome({Key? key}) : super(key: key);

  @override
  State<NoteHome> createState() => _NoteHomeState();
}

enum Priority { low, medium, high, alert }

class _NoteHomeState extends State<NoteHome> {
  final TextEditingController noteController = TextEditingController();
  List<Map<String, dynamic>> notes = []; // List to store notes with priority
  Priority selectedPriority = Priority.low; // Default priority

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Priority settings at the top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Priority.values.map((priority) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Filter notes by priority
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(getPriorityIcon(priority), color: getPriorityColor(priority)),
                      Text(priority.toString().split('.').last.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showNoteDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Create New Note'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: getPriorityColor(notes[index]['priority']),
                    child: ListTile(
                      title: Text(notes[index]['text']),
                      leading: Icon(getPriorityIcon(notes[index]['priority'])),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoteDialog() {
    String note = '';
    Priority priority = Priority.low;
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  note = value;
                },
                decoration: const InputDecoration(hintText: 'Enter your note'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: Priority.values.map((priorityOption) {
                  return GestureDetector(
                    onTap: () {
                      priority = priorityOption;
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(getPriorityIcon(priorityOption), color: getPriorityColor(priorityOption)),
                        Text(priorityOption.toString().split('.').last.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: const Text('Select Date'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (pickedTime != null && pickedTime != selectedTime) {
                    setState(() {
                      selectedTime = pickedTime;
                    });
                  }
                },
                child: const Text('Select Time'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (note.isNotEmpty) {
                  String dateTime = '$selectedDate ${selectedTime.format(context)}';
                  setState(() {
                    notes.add({
                      'text': '[$dateTime] $note',
                      'priority': priority,
                    });
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  IconData getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.low_priority;
      case Priority.medium:
        return Icons.priority_high;
      case Priority.high:
        return Icons.warning;
      case Priority.alert:
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.yellow;
      case Priority.high:
        return Colors.orange;
      case Priority.alert:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
