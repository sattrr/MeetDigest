import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:meetdigest/themes/app_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_border/dotted_border.dart';
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
      
      _showUploadSuccessPopup();
    }
  }

  void _showUploadSuccessPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppPalette.colorPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppPalette.colorPrimary,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Upload Berhasil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'File berhasil diupload',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Mengerti', 
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload_file, color: Colors.green, size: 40),
                      SizedBox(height: 8),
                      Text(
                        "Upload File",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Catatan Anda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = uploadedFiles[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.notes, size: 32, color: Colors.grey[700]),
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
                          child: Text('Ubah'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus'),
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
    );
  }
}