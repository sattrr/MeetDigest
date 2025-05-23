import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryScreen extends StatefulWidget {
  final String summaryText;

  const SummaryScreen({super.key, required this.summaryText});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _saveNote(widget.summaryText);
  }

  Future<void> _saveNote(String note) async {
    prefs = await SharedPreferences.getInstance();
    List<String> savedNotes = prefs.getStringList('notes') ?? [];
    savedNotes.add(note);
    await prefs.setStringList('notes', savedNotes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Ringkasan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(widget.summaryText),
      ),
    );
  }
}