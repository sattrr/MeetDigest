import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final String title;
  final String summary;

  const SummaryScreen({
    super.key,
    this.title = "Judul Catatan",
    this.summary = "Ini adalah ringkasan teks hasil rekaman atau upload.",
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: title);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: TextField(
          controller: titleController,
          decoration: InputDecoration(border: InputBorder.none),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(summary),
      ),
    );
  }
}