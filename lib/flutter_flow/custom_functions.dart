import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

List<DateTime> getTimestampRange(DateTime selectedDate) {
  // Получаем начало дня (00:00:00)
  DateTime startOfDay = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);

  // Получаем конец дня (23:59:59)
  DateTime endOfDay = DateTime(
      selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

  return [startOfDay, endOfDay];
}

List<EmotionDayStruct> fetchEmotion(List<EmotionsRecord> documents) {
  List<EmotionDayStruct> result = [];

  for (var doc in documents) {
    // Проверяем, что поля не null
    if (doc.timeRecord != null && doc.emotionValue != null) {
      result.add(EmotionDayStruct(
        timeRecord: doc.timeRecord!,
        emotion: doc.emotionValue!,
      ));
    }
  }

  return result;
}
