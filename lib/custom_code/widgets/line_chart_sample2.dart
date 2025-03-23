// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
import '/auth/firebase_auth/auth_util.dart';

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  bool showAvg = false;
  List<FlSpot> emotionSpots = [];
  List<String> dateLabels = [];

  final Map<int, String> emotionEmojis = {
    1: '😢', // Bardzo źle
    2: '😟', // Źle
    3: '😐', // Neutralnie
    4: '😊', // Dobrze
    5: '😃', // Super
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

    List<FlSpot> spots = [];
    groupedData.entries.toList().asMap().forEach((i, entry) {
      double avgEmotion =
          entry.value.reduce((a, b) => a + b) / entry.value.length;
      spots.add(FlSpot(i.toDouble(), avgEmotion));
    });

    setState(() {
      emotionSpots = spots;
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
        child: LineChart(
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

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: bottomTitleWidgets,
            reservedSize: 30,
            interval: 1,
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
      minX: 0,
      maxX: emotionSpots.isNotEmpty ? (emotionSpots.length - 1).toDouble() : 0,
      minY: 1,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: emotionSpots,
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
