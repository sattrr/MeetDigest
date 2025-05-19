import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:record/record.dart';
import 'home_screen.dart';
import 'summary_screen.dart';

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

      final path = '$musicDir/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

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

    setState(() {
      _isRecording = false;
      _elapsed = Duration.zero;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rekaman disimpan di: $_recordPath')),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
  }

  String _formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:'
        '${(d.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(d.inSeconds % 60).toString().padLeft(2, '0')}';
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
      appBar: AppBar(title: const Text("MeetDigest")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (!_isRecording) {
                _startRecording();
              }
            },
            child: Icon(
              Icons.mic,
              size: 80,
              color: _isRecording ? Colors.red : Colors.teal,
            ),
          ),
          const SizedBox(height: 10),
          Text(_formatDuration(_elapsed), style: const TextStyle(fontSize: 24)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text("Kembali"),
              ),
              ElevatedButton(
                onPressed: _isRecording ? _stopRecording : null,
                child: const Text("Stop"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
            child: const Text("Proses"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}