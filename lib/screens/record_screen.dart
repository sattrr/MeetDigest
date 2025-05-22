import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meetdigest/themes/app_palette.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:record/record.dart';
import 'home_screen.dart';
import 'summary_screen.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String _recordPath = '';
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  double _amplitude = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _startRecording() async {
    final micStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    if (!micStatus.isGranted || !storageStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin dibutuhkan untuk merekam')),
      );
      return;
    }

    try {
      final musicDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_MUSIC,
      );

      final path =
          '$musicDir/record_meetdigest_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordPath = path;
        _elapsed = Duration.zero;
      });

      _startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memulai rekaman: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    await _audioRecorder.stop();
    _timer?.cancel();

    final savedDuration = _elapsed;
    
    setState(() {
      _isRecording = false;
      _elapsed = Duration.zero;
      _amplitude = 0.0;
    });

    _showRecordingSavedPopup(_recordPath, savedDuration);
  }

  void _showRecordingSavedPopup(String filePath, Duration duration) {
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
                    'Rekaman Tersimpan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Durasi: ${_formatDuration(duration)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      filePath.split('/').last,
                      style: TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
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
                      onPressed: () => Navigator.pop(context),
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      setState(() {
        _elapsed += const Duration(milliseconds: 300);
      });

      final amp = await _audioRecorder.getAmplitude();
      setState(() {
        _amplitude = amp.current.clamp(0.0, 1.0);
      });
    });
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    final centiseconds = (d.inMilliseconds % 1000 ~/ 10).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds:$centiseconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "MeetDigest",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 125),

            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_isRecording) {
                      _startRecording();
                    } else {
                      _stopRecording();
                    }
                  },
                  child: Container(
                    width: 145,
                    height: 145,
                    decoration: BoxDecoration(
                      color: _isRecording ? AppPalette.colorPrimary : AppPalette.colorSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mic, size: 60, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 38, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                _formatDuration(_elapsed),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),

            const SizedBox(height: 64),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundButton(Icons.reply, onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Navbar()),
                  );
                }),
                const SizedBox(width: 32),
                _buildRoundButton(Icons.stop,
                    color: Colors.red,
                    onPressed: _isRecording ? _stopRecording : null),
                const SizedBox(width: 32),
                _buildRoundButton(Icons.pause, onPressed: () {
                  // (TODO: implementasi pause)
                }),
              ],
            ),

            const SizedBox(height: 54),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SummaryScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 68, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Proses",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundButton(IconData icon,
      {VoidCallback? onPressed, Color? color}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.grey[200],
        ),
        child: Icon(icon, color: color == null ? Colors.black : Colors.white),
      ),
    );
  }
}