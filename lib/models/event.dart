import 'package:flutter/material.dart';
import 'package:flutter_firebase/models/activity.dart';
import 'package:flutter_firebase/models/participant.dart';

class Event{
  final String? nameDoc;
  final String? title;
  final String? description;
  final DateTime? date;
  final TimeOfDay? start;
  final TimeOfDay? end;
  final String? location;
  final bool? isPublicEvent;
  final String? creatorUid;
  final List<Activity>? activities;
  final List<Participant>? participants;

  Event({ this.nameDoc, this.title, this.description, this.date, this.start, this.end, this.location, this.isPublicEvent, this.creatorUid, this.activities, this.participants });
}