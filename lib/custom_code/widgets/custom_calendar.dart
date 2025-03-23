// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Карта для хранения значений эмоций и их иконок (заполняется из Firestore)
  Map<int, String> _emotionIcons = {};

  @override
  void initState() {
    super.initState();
    _loadEmotionIcons(); // Загружаем иконки из Firestore
  }

  /// Функция для загрузки данных из Firestore
  Future<void> _loadEmotionIcons() async {
    final emotionsRef = FirebaseFirestore.instance.collection('emotion');
    final snapshot = await emotionsRef.get();

    if (snapshot.docs.isEmpty) return; // Если данных нет, выходим

    // Чистим карту перед обновлением
    Map<int, String> loadedIcons = {};

    for (var doc in snapshot.docs) {
      int? emotionValue = doc['emotionValue']; // Числовое значение эмоции
      String? imageUrl = doc['icon'].toString(); // URL изображения

      if (emotionValue != null && imageUrl != null && imageUrl.isNotEmpty) {
        loadedIcons[emotionValue] = imageUrl; // Записываем в словарь
      }
    }

    // Обновляем состояние после загрузки данных
    setState(() {
      _emotionIcons = loadedIcons;
    });
  }

  /// Получение ссылки на иконку по значению эмоции
  String getEmotionIconUrl(int emotion) {
    return _emotionIcons[emotion] ??
        ""; // Если эмоция не найдена — пустая строка
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 400,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            // Ищем эмоцию на этот день
            final emotionRecord = FFAppState().monthlyEmotions.firstWhere(
                  (entry) =>
                      entry.timeRecord != null && // Проверяем, что дата не null
                      entry.timeRecord!.year == date.year &&
                      entry.timeRecord!.month == date.month &&
                      entry.timeRecord!.day == date.day,
                  orElse: () =>
                      EmotionDayStruct(), // Если нет записи, вернёт пустой объект
                );

            // Получаем ссылку на иконку эмоции
            String iconUrl = getEmotionIconUrl(emotionRecord.emotion ?? 0);

            return Center(
              child: iconUrl.isNotEmpty
                  ? Image.network(iconUrl, height: 24, width: 24)
                  : Text(date.day.toString(), style: TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    );
  }
}
