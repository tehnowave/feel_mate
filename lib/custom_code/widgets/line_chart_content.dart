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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_line_chart/simple_line_chart.dart';

class LineChartContent extends StatefulWidget {
  const LineChartContent({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<LineChartContent> createState() => _LineChartContentState();
}

class _LineChartContentState extends State<LineChartContent> {
  LineChartData? data;
  bool isLoading = true; // Флаг загрузки

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Функция для получения данных из Firestore
  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('emotions')
          .orderBy('timeRecord', descending: false) // Сортировка по дате
          .get();

      final List<DataPoint> dataPoints = [];

      for (var doc in querySnapshot.docs) {
        final dataMap = doc.data() as Map<String, dynamic>;
        final DateTime date = (dataMap['timeRecord'] as Timestamp).toDate();
        final double emotionValue = (dataMap['emotionValue'] as int).toDouble();

        dataPoints.add(DataPoint(
          x: date.millisecondsSinceEpoch.toDouble(), // Время в миллисекундах
          y: emotionValue, // Уровень эмоции
        ));
      }

      setState(() {
        data = LineChartData(datasets: [
          Dataset(label: 'Emotions', dataPoints: dataPoints),
        ]);
        isLoading = false; // Скрываем загрузку
      });
    } catch (e) {
      print('Ошибка при получении данных: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Показываем индикатор загрузки
          : data != null
              ? LineChart(
                  style: LineChartStyle.fromTheme(context),
                  seriesHeight: widget.height ?? 300,
                  data: data!,
                )
              : const Center(child: Text('Нет данных')),
    );
  }
}
