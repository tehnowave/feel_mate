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
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '/auth/firebase_auth/auth_util.dart';

class BarChartSample extends StatefulWidget {
  const BarChartSample({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<BarChartSample> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  List<Color> barColors = [
    Colors.cyan,
    Colors.blue,
  ];

  List<BarChartGroupData> barGroups = [];
  List<String> dateLabels = [];

  final Map<int, String> emotionEmojis = {
    1: '😢', // Очень плохо
    2: '😟', // Плохо
    3: '😐', // Нейтрально
    4: '😊', // Хорошо
    5: '😃', // Отлично
  };

  @override
  void initState() {
    super.initState();
    fetchEmotionData();
  }

  Future<void> fetchEmotionData() async {
    final now = DateTime.now();
    final oneMonthAgo = now.subtract(Duration(days: 30));

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('emotions')
        .where('userRef', isEqualTo: currentUserReference)
        .where('timeRecord', isGreaterThanOrEqualTo: oneMonthAgo)
        .orderBy('timeRecord', descending: false)
        .get();

    Map<String, List<int>> groupedData = {};
    List<String> labels = [];
    for (var doc in snapshot.docs) {
      DateTime date = (doc['timeRecord'] as Timestamp).toDate();
      String dayKey = "${date.year}-${date.month}-${date.day}";
      String formattedDate = DateFormat("dd/MM").format(date);

      if (!labels.contains(formattedDate)) {
        labels.add(formattedDate);
      }

      int emotion = doc['emotionValue'];

      if (!groupedData.containsKey(dayKey)) {
        groupedData[dayKey] = [];
      }
      groupedData[dayKey]!.add(emotion);
    }

    List<BarChartGroupData> bars = [];
    groupedData.entries.toList().asMap().forEach((i, entry) {
      double avgEmotion =
          entry.value.reduce((a, b) => a + b) / entry.value.length;
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: avgEmotion,
              color: barColors[i % barColors.length],
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });

    setState(() {
      barGroups = bars;
      dateLabels = labels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: BarChart(
          mainData(),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() >= 0 && value.toInt() < dateLabels.length) {
      return Text(
        dateLabels[value.toInt()],
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      );
    }
    return const Text('');
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final text = emotionEmojis[value.toInt()] ?? '';
    return Text(
      text,
      style: const TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    );
  }

  BarChartData mainData() {
    return BarChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 30,
            interval: 4,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey),
      ),
      barGroups: barGroups,
    );
  }
}
