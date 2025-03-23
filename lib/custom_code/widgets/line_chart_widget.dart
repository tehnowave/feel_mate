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

// import 'package:simple_line_chart/simple_line_chart.dart';

// // Set your widget name, define your parameter, and then add the
// // boilerplate code using the green button on the right!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late LineChart lineChart;
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

      final Map<DateTime, double> data = {}; // Карта для хранения данных

      for (var doc in querySnapshot.docs) {
        final dataMap = doc.data() as Map<String, dynamic>;
        final DateTime date = (dataMap['timeRecord'] as Timestamp).toDate();
        final double emotionValue = (dataMap['emotionValue'] as int).toDouble();
        data[date] = emotionValue;
      }

      setState(() {
        lineChart =
            LineChart.fromDateTimeMaps([data], [Colors.blue], ['Emotions']);
        isLoading = false; // Скрываем загрузку
      });
    } catch (e) {
      print('Ошибка при получении данных: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 250,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Показать индикатор загрузки
          : AnimatedLineChart(
              lineChart,
              toolTipColor: Colors.white,
              gridColor: Colors.black54,
              textStyle: const TextStyle(fontSize: 10, color: Colors.black54),
              showMarkerLines: true,
              legends: const [
                Legend(
                    title: 'Emotions',
                    color: Colors.blue,
                    showLeadingLine: true),
              ],
              legendsRightLandscapeMode: true,
            ),
    );
  }
}

// import 'package:intl/intl.dart'; // Для форматирования даты
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:graphic/graphic.dart';

// class LineChartWidget extends StatefulWidget {
//   const LineChartWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Map<String, dynamic>> chartData = [];
//   bool isLoading = true;
//   final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

//   // Маппинг эмоций в смайлики
//   final Map<int, String> emotionIcons = {
//     1: '😢', // Очень грустный
//     2: '😞', // Грустный
//     3: '😐', // Нейтральный
//     4: '🙂', // Счастливый
//     5: '😃', // Очень счастливый
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('emotions')
//           .orderBy('timeRecord', descending: false)
//           .get();

//       final List<Map<String, dynamic>> tempData = [];

//       for (var doc in querySnapshot.docs) {
//         final dataMap = doc.data() as Map<String, dynamic>;
//         final DateTime date = (dataMap['timeRecord'] as Timestamp).toDate();
//         final int emotionValue = dataMap['emotionValue'] as int;

//         tempData.add({
//           'time': date,
//           'emotion': emotionValue.toDouble(),
//         });
//       }

//       setState(() {
//         chartData = tempData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при получении данных: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : chartData.isNotEmpty
//               ? SizedBox(
//                   width: widget.width ?? double.infinity,
//                   height: widget.height ?? 300,
//                   child: Chart(
//                     data: chartData,
//                     variables: {
//                       'time': Variable(
//                         accessor: (Map map) => map['time'] as DateTime,
//                         scale: TimeScale(
//                           formatter: (time) =>
//                               _monthDayFormat.format(time as DateTime),
//                         ),
//                       ),
//                       'emotion': Variable(
//                         accessor: (Map map) => map['emotion'] as double,
//                         scale: LinearScale(
//                           min: 1,
//                           max: 5,
//                           formatter: (value) {
//                             int emotion = (value as double).round();
//                             return emotionIcons[emotion] ??
//                                 '❓'; // Смайлик вместо цифры
//                           },
//                         ),
//                       ),
//                     },
//                     marks: [
//                       LineMark(
//                         shape: ShapeEncode(value: BasicLineShape()),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                       PointMark(
//                         shape: ShapeEncode(value: CircleShape()),
//                         size: SizeEncode(value: 5),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                     ],
//                     axes: [
//                       Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                       Defaults.verticalAxis, // Ось Y (эмоции в смайликах)
//                     ],
//                   ),
//                 )
//               : const Center(child: Text('Нет данных для отображения')),
//     );
//   }
// }

// import 'package:intl/intl.dart'; // Для форматирования даты
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:graphic/graphic.dart';

// class LineChartWidget extends StatefulWidget {
//   const LineChartWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Map<String, dynamic>> chartData = [];
//   bool isLoading = true;
//   final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

//   // Маппинг эмоций в смайлики
//   final Map<int, String> emotionIcons = {
//     1: '🥵', // Очень грустный
//     2: '😞', // Грустный (замена ☹️)
//     3: '😐', // Нейтральный
//     4: '🙂', // Счастливый
//     5: '🤢', // Очень счастливый
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('emotions')
//           .orderBy('timeRecord', descending: false)
//           .get();

//       final List<Map<String, dynamic>> tempData = [];

//       for (var doc in querySnapshot.docs) {
//         final dataMap = doc.data() as Map<String, dynamic>;
//         final DateTime date = (dataMap['timeRecord'] as Timestamp).toDate();
//         final int emotionValue = dataMap['emotionValue'] as int;

//         tempData.add({
//           'time': date,
//           'emotion': emotionValue.toDouble(),
//         });
//       }

//       setState(() {
//         chartData = tempData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при получении данных: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : chartData.isNotEmpty
//               ? SizedBox(
//                   width: widget.width ?? double.infinity,
//                   height: widget.height ?? 300,
//                   child: Chart(
//                     data: chartData,
//                     variables: {
//                       'time': Variable(
//                         accessor: (Map map) => map['time'] as DateTime,
//                         scale: TimeScale(
//                           formatter: (time) =>
//                               _monthDayFormat.format(time as DateTime),
//                         ),
//                       ),
//                       'emotion': Variable(
//                         accessor: (Map map) => map['emotion'] as double,
//                         scale: LinearScale(
//                           min: 1,
//                           max: 5,
//                           formatter: (value) {
//                             int emotion = (value as double).round();
//                             return emotionIcons[emotion] ??
//                                 '❓'; // Смайлик вместо цифры
//                           },
//                         ),
//                       ),
//                     },
//                     marks: [
//                       LineMark(
//                         shape: ShapeEncode(value: BasicLineShape()),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                       PointMark(
//                         shape: ShapeEncode(value: CircleShape()),
//                         size: SizeEncode(value: 5),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                     ],
//                     axes: [
//                       Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                       AxisGuide(
//                         label: LabelStyle(
//                           textStyle: const TextStyle(
//                             fontSize: 18, // Увеличиваем размер смайликов
//                           ),
//                         ),
//                         line: PaintStyle(
//                           strokeWidth: 1, // Толщина оси Y
//                           strokeColor: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const Center(child: Text('Нет данных для отображения')),
//     );
//   }
// }

// /////////////////////////////////////////////////////////////////////
// import 'package:intl/intl.dart'; // Для форматирования даты
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:graphic/graphic.dart';

// class LineChartWidget extends StatefulWidget {
//   const LineChartWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Map<String, dynamic>> chartData = [];
//   bool isLoading = true;
//   final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

//   // Маппинг эмоций в смайлики
//   final Map<int, String> emotionIcons = {
//     1: '😢', // Очень грустный
//     2: '😞', // Грустный
//     3: '😐', // Нейтральный
//     4: '🙂', // Счастливый
//     5: '😃', // Очень счастливый
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('emotions')
//           .orderBy('timeRecord', descending: false)
//           .get();

//       final List<Map<String, dynamic>> tempData = [];

//       for (var doc in querySnapshot.docs) {
//         final dataMap = doc.data() as Map<String, dynamic>;
//         final Timestamp? timeRecord = dataMap['timeRecord'] as Timestamp?;
//         final int? emotionValue = dataMap['emotionValue'] as int?;

//         if (timeRecord != null && emotionValue != null) {
//           final DateTime date = timeRecord.toDate();
//           tempData.add({
//             'time': date,
//             'emotion': emotionValue.toDouble(),
//           });
//         }
//       }

//       setState(() {
//         chartData = tempData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при получении данных: $e');
//       setState(() => isLoading = false);
//       // Можно добавить вывод ошибки пользователю, например, через SnackBar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка при загрузке данных: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : chartData.isNotEmpty
//               ? SizedBox(
//                   width: widget.width ?? double.infinity,
//                   height: widget.height ?? 300,
//                   child: Chart(
//                     data: chartData,
//                     variables: {
//                       'time': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['time'] as DateTime,
//                         scale: TimeScale(
//                           formatter: (time) =>
//                               _monthDayFormat.format(time as DateTime),
//                         ),
//                       ),
//                       'emotion': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['emotion'] as double,
//                         scale: LinearScale(
//                           min: 1,
//                           max: 5,
//                           formatter: (value) {
//                             int emotion = (value as double).round();
//                             return emotionIcons[emotion] ??
//                                 '❓'; // Смайлик вместо цифры
//                           },
//                         ),
//                       ),
//                     },
//                     marks: [
//                       LineMark(
//                         shape: ShapeEncode(value: BasicLineShape()),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                       PointMark(
//                         shape: ShapeEncode(value: CircleShape()),
//                         size: SizeEncode(value: 10),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                     ],
//                     axes: [
//                       Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                       Defaults.verticalAxis, // Ось Y (эмоции в смайликах)
//                     ],
//                   ),
//                 )
//               : const Center(child: Text('Нет данных для отображения')),
//     );
//   }
// }

// import 'package:intl/intl.dart'; // Для форматирования даты
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:graphic/graphic.dart';

// class LineChartWidget extends StatefulWidget {
//   const LineChartWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Map<String, dynamic>> chartData = [];
//   bool isLoading = true;
//   final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

//   // Маппинг эмоций в смайлики
//   final Map<int, String> emotionIcons = {
//     1: '😢', // Очень грустный
//     2: '🤔', // Грустный
//     3: '😐', // Нейтральный
//     4: '🙂', // Счастливый
//     5: '😃', // Очень счастливый
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('emotions')
//           .orderBy('timeRecord', descending: false)
//           .get();

//       final List<Map<String, dynamic>> tempData = [];

//       for (var doc in querySnapshot.docs) {
//         final dataMap = doc.data() as Map<String, dynamic>;
//         final Timestamp? timeRecord = dataMap['timeRecord'] as Timestamp?;
//         final int? emotionValue = dataMap['emotionValue'] as int?;

//         if (timeRecord != null && emotionValue != null) {
//           final DateTime date = timeRecord.toDate();
//           tempData.add({
//             'time': date,
//             'emotion': emotionValue.toDouble(),
//           });
//         }
//       }

//       setState(() {
//         chartData = tempData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при получении данных: $e');
//       setState(() => isLoading = false);
//       // Можно добавить вывод ошибки пользователю, например, через SnackBar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка при загрузке данных: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : chartData.isNotEmpty
//               ? SizedBox(
//                   width: widget.width ?? double.infinity,
//                   height: widget.height ?? 300,
//                   child: Chart(
//                     data: chartData,
//                     variables: {
//                       'time': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['time'] as DateTime,
//                         scale: TimeScale(
//                           formatter: (time) =>
//                               _monthDayFormat.format(time as DateTime),
//                         ),
//                       ),
//                       'emotion': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['emotion'] as double,
//                         scale: LinearScale(
//                           min: 1,
//                           max: 5,
//                           formatter: (value) {
//                             int emotion = (value as double).round();
//                             return emotionIcons[emotion] ??
//                                 '❓'; // Смайлик вместо цифры
//                           },
//                         ),
//                       ),
//                     },
//                     marks: [
//                       LineMark(
//                         shape: ShapeEncode(value: BasicLineShape()),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                       PointMark(
//                         shape: ShapeEncode(value: CircleShape()),
//                         size: SizeEncode(value: 5), // Увеличиваем размер иконок
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                     ],
//                     // axes: [
//                     //   Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                     //   Defaults.verticalAxis, // Ось Y (эмоции в смайликах)
//                     // ],

//                     axes: [
//                       Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                       AxisGuide(
//                         position: 0, // Позиция оси Y
//                         label: LabelStyle(
//                           textStyle: TextStyle(
//                             fontSize:
//                                 10, // Увеличиваем размер текста (смайликов)
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const Center(child: Text('Нет данных для отображения')),
//     );
//   }
// }

// import 'package:intl/intl.dart'; // Для форматирования даты
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:graphic/graphic.dart';

// class LineChartWidget extends StatefulWidget {
//   const LineChartWidget({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<LineChartWidget> createState() => _LineChartWidgetState();
// }

// class _LineChartWidgetState extends State<LineChartWidget> {
//   List<Map<String, dynamic>> chartData = [];
//   bool isLoading = true;
//   final DateFormat _monthDayFormat = DateFormat('dd/MM'); // Формат для даты

//   // Маппинг эмоций в смайлики
//   final Map<int, String> emotionIcons = {
//     1: '😢', // Очень грустный
//     2: '🤔', // Грустный
//     3: '😐', // Нейтральный
//     4: '🙂', // Счастливый
//     5: '😃', // Очень счастливый
//   };

//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('emotions')
//           .orderBy('timeRecord', descending: false)
//           .get();

//       final List<Map<String, dynamic>> tempData = [];

//       for (var doc in querySnapshot.docs) {
//         final dataMap = doc.data() as Map<String, dynamic>;
//         final Timestamp? timeRecord = dataMap['timeRecord'] as Timestamp?;
//         final int? emotionValue = dataMap['emotionValue'] as int?;

//         if (timeRecord != null && emotionValue != null) {
//           final DateTime date = timeRecord.toDate();
//           tempData.add({
//             'time': date,
//             'emotion': emotionValue.toDouble(),
//           });
//         }
//       }

//       setState(() {
//         chartData = tempData;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Ошибка при получении данных: $e');
//       setState(() => isLoading = false);
//       // Можно добавить вывод ошибки пользователю, например, через SnackBar
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ошибка при загрузке данных: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : chartData.isNotEmpty
//               ? SizedBox(
//                   width: widget.width ?? double.infinity,
//                   height: widget.height ?? 300,
//                   child: Chart(
//                     data: chartData,
//                     variables: {
//                       'time': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['time'] as DateTime,
//                         scale: TimeScale(
//                           formatter: (time) =>
//                               _monthDayFormat.format(time as DateTime),
//                         ),
//                       ),
//                       'emotion': Variable(
//                         accessor: (Map<String, dynamic> map) =>
//                             map['emotion'] as double,
//                         scale: LinearScale(
//                           min: 1,
//                           max: 5,
//                           formatter: (value) {
//                             int emotion = (value as double).round();
//                             return emotionIcons[emotion] ??
//                                 '❓'; // Смайлик вместо цифры
//                           },
//                         ),
//                       ),
//                     },
//                     marks: [
//                       LineMark(
//                         shape: ShapeEncode(value: BasicLineShape()),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                       PointMark(
//                         shape: ShapeEncode(value: CircleShape()),
//                         size: SizeEncode(value: 5),
//                         color: ColorEncode(value: Colors.blue),
//                       ),
//                     ],
//                     axes: [
//                       Defaults.horizontalAxis, // Ось X (дата dd/MM)
//                       AxisGuide(
//                         position: 0, // Позиция оси Y
//                         label: LabelStyle(
//                           textStyle: TextStyle(
//                             fontSize:
//                                 20, // Увеличиваем размер текста (смайликов)
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : const Center(child: Text('Нет данных для отображения')),
//     );
//   }
// }
