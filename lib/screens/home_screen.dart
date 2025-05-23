import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meetdigest/themes/app_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'summary_screen.dart';
import 'package:meetdigest/models/note_model.dart';
import 'package:meetdigest/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _pickAudioOrVideo() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Media',
      extensions: ['mp3', 'wav', 'aac', 'm4a', 'mp4', 'mkv', 'mov'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      final newFile = File(file.path);
      _showLoading();

      try {
        final summary = await _sendToApi(newFile);
        final note = Note(filePath: newFile.path, summary: summary);

        setState(() {
          notes.add(note);
        });

        await _saveNotes();
        if (mounted) Navigator.pop(context);
        _showUploadSuccessPopup();
      } catch (e) {
        if (mounted) Navigator.pop(context);
        _showError('Gagal memproses file. Coba lagi nanti.\nError: $e');
      }
    }
  }

  Future<String> _sendToApi(File file) async {
    final uri = Uri.parse(AppConfig.apiBaseUrl);
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();

      final respStr = await response.stream.bytesToString();
      print('Response body: $respStr');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(respStr);
        final summary = jsonResponse['text'] ?? jsonResponse['summary'] ?? 'Tidak ada ringkasan';

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('last_summary', summary);
        } catch (e) {
          print("Gagal menyimpan summary: $e");
        }

        if (!context.mounted) return summary;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SummaryScreen(summaryText: summary),
          ),
        );

        return summary;
      } else {
        print('Gagal status: ${response.statusCode}');
        if (!context.mounted) return 'Gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses file')),
        );
        return Future.error('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      if (!context.mounted) return 'Error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      return Future.error(e);
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((note) => json.encode(note.toJson())).toList();
    await prefs.setStringList('notes', jsonList);
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('notes') ?? [];
    setState(() {
      notes = jsonList.map((s) => Note.fromJson(json.decode(s))).toList();
    });
  }

  Future<void> _deleteNote(int index) async {
    setState(() {
      notes.removeAt(index);
    });
    await _saveNotes();
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showUploadSuccessPopup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            const Text('Upload Berhasil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('File berhasil diringkas dan disimpan.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: _pickAudioOrVideo,
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 1.5,
                dashPattern: [6, 5],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  width: 300,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: Colors.green, size: 40),
                      SizedBox(height: 8),
                      Text("Upload File", style: TextStyle(color: Colors.green, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text("Catatan Anda", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final filename = note.filePath.split(Platform.pathSeparator).last;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.notes, size: 32, color: Colors.grey[700]),
                    title: Text("Catatan ${index + 1}"),
                    subtitle: Text(filename),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SummaryScreen(summaryText: note.summary),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteNote(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}