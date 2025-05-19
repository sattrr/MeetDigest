import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> uploadedFiles = [];

  Future<void> _pickAudioOrVideo() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'Media',
      extensions: ['mp3', 'wav', 'aac', 'm4a', 'mp4', 'mkv', 'mov'],
    );

    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      setState(() {
        uploadedFiles.add(File(file.path));
      });
      await _saveUploadedFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File berhasil diupload')),
      );
    }
  }

  Future<void> _loadUploadedFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('uploaded_files') ?? [];
    setState(() {
      uploadedFiles =
          paths.map((path) => File(path)).where((f) => f.existsSync()).toList();
    });
  }

  Future<void> _saveUploadedFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = uploadedFiles.map((f) => f.path).toList();
    await prefs.setStringList('uploaded_files', paths);
  }

  Future<void> _deleteFile(int index) async {
    setState(() {
      uploadedFiles.removeAt(index);
    });
    await _saveUploadedFiles();
  }

  @override
  void initState() {
    super.initState();
    _loadUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MeetDigest"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _pickAudioOrVideo,
              child: const Text("Upload Audio/Video File"),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Catatan Anda",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = uploadedFiles[index];
                return ListTile(
                  title: Text("Catatan ${index + 1}"),
                  subtitle: Text(file.path.split(Platform.pathSeparator).last),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SummaryScreen(),
                      ),
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SummaryScreen(),
                          ),
                        );
                      } else if (value == 'delete') {
                        await _deleteFile(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Buka'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus'),
                      ),
                    ],
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