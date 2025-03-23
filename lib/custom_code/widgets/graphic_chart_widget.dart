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

import 'package:intl/intl.dart'; // Для форматирования даты
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graphic/graphic.dart';

class GraphicChartWidget extends StatefulWidget {
  const GraphicChartWidget({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<GraphicChartWidget> createState() => _GraphicChartWidgetState();
}

class _GraphicChartWidgetState extends State<GraphicChartWidget> {
  List<Map<String, dynamic>> chartData = [];
  bool isLoading = true;
  final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('emotions')
          .orderBy('timeRecord', descending: false)
          .get();

      final List<Map<String, dynamic>> tempData = [];

      for (var doc in querySnapshot.docs) {
        final dataMap = doc.data() as Map<String, dynamic>;
        final DateTime date = (dataMap['timeRecord'] as Timestamp).toDate();
        final int emotionValue = dataMap['emotionValue'] as int;

        tempData.add({
          'time': date,
          'emotion': emotionValue.toDouble(),
        });
      }

      setState(() {
        chartData = tempData;
        isLoading = false;
      });
    } catch (e) {
      print('Ошибка при получении данных: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chartData.isNotEmpty
              ? SizedBox(
                  width: widget.width ?? double.infinity,
                  height: widget.height ?? 300,
                  child: Chart(
                    data: chartData,
                    variables: {
                      'time': Variable(
                        accessor: (Map map) => map['time'] as DateTime,
                        scale: TimeScale(
                          formatter: (time) =>
                              _monthDayFormat.format(time as DateTime),
                        ),
                      ),
                      'emotion': Variable(
                        accessor: (Map map) => map['emotion'] as double,
                        scale: LinearScale(min: 0, max: 5),
                      ),
                    },
                    marks: [
                      LineMark(
                        shape: ShapeEncode(value: BasicLineShape()),
                        color: ColorEncode(value: Colors.blue),
                      ),
                      PointMark(
                        shape: ShapeEncode(value: CircleShape()),
                        size: SizeEncode(value: 5),
                        color: ColorEncode(value: Colors.blue),
                      ),
                    ],
                    axes: [
                      Defaults.horizontalAxis, // Ось X (даты в формате dd/MM)
                      Defaults.verticalAxis, // Ось Y (уровень эмоции)
                    ],
                  ),
                )
              : const Center(child: Text('Нет данных для отображения')),
    );
  }
}
