import 'package:flutter/material.dart';

class FilterMenu extends StatelessWidget {
  final List<String> categories;
  final List<String> priorities;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  FilterMenu({
    required this.categories,
    required this.priorities,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
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
            children: categories.map((category) {
              return FilterChip(
                label: Text(category),
                selected: selectedFilter == category,
                onSelected: (selected) {
                  onFilterSelected(category);
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
            children: priorities.map((priority) {
              return FilterChip(
                label: Text(priority),
                selected: selectedFilter == priority,
                onSelected: (selected) {
                  onFilterSelected(priority);
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
  }
}
