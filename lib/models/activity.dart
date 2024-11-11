import 'package:flutter/material.dart';

class Activity{
  final String? nameDoc;
  final String? title;
  final String? description;
  final TimeOfDay? start;
  final TimeOfDay? end;

  Activity({ this.nameDoc, this.title, this.description, this.start, this.end });
}