import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note {
  final String filePath;
  final String summary;

  Note({required this.filePath, required this.summary});

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'summary': summary,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        filePath: json['filePath'],
        summary: json['summary'],
      );
}