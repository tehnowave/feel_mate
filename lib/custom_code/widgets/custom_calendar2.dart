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

// // Automatic FlutterFlow imports
// import '/backend/backend.dart';
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CustomCalendar2 extends StatefulWidget {
//   const CustomCalendar2({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<CustomCalendar2> createState() => _CustomCalendar2State();
// }

// class _CustomCalendar2State extends State<CustomCalendar2> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   double? _averageEmotion;

//   Map<int, String> _emotionIcons = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadEmotionIcons();
//   }

//   Future<void> _loadEmotionIcons() async {
//     final emotionsRef = FirebaseFirestore.instance.collection('emotion');
//     final snapshot = await emotionsRef.get();

//     if (snapshot.docs.isEmpty) return;

//     Map<int, String> loadedIcons = {};
//     for (var doc in snapshot.docs) {
//       int? emotionValue = doc['emotionValue'];
//       String? imageUrl = doc['icon'].toString();
//       if (emotionValue != null && imageUrl != null && imageUrl.isNotEmpty) {
//         loadedIcons[emotionValue] = imageUrl;
//       }
//     }

//     setState(() {
//       _emotionIcons = loadedIcons;
//     });
//   }

//   String getEmotionIconUrl(int emotion) {
//     return _emotionIcons[emotion] ?? "";
//   }

//   Future<void> _calculateAverageEmotion() async {
//     if (_startDate == null || _endDate == null) return;
//     final emotionsRef = FirebaseFirestore.instance.collection('emotions');
//     final snapshot = await emotionsRef
//         .where('timeRecord', isGreaterThanOrEqualTo: _startDate)
//         .where('timeRecord', isLessThanOrEqualTo: _endDate)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       setState(() {
//         _averageEmotion = null;
//       });
//       return;
//     }

//     double total = 0;
//     int count = 0;
//     for (var doc in snapshot.docs) {
//       int? emotionValue = doc['emotionValue'];
//       if (emotionValue != null) {
//         total += emotionValue;
//         count++;
//       }
//     }

//     setState(() {
//       _averageEmotion = total / count;
//     });
//   }

//   void _selectDate(BuildContext context, bool isStartDate) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStartDate
//           ? _startDate ?? DateTime.now()
//           : _endDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//       _calculateAverageEmotion();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () => _selectDate(context, true),
//               child: Text(_startDate == null
//                   ? "Select start date"
//                   : "Start: ${_startDate!.toLocal()}".split(' ')[0]),
//             ),
//             ElevatedButton(
//               onPressed: () => _selectDate(context, false),
//               child: Text(_endDate == null
//                   ? "Select end date"
//                   : "End: ${_endDate!.toLocal()}".split(' ')[0]),
//             ),
//           ],
//         ),
//         if (_averageEmotion != null)
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Text(
//                 "Average emotion: ${_averageEmotion!.toStringAsFixed(2)}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//         Container(
//           width: widget.width ?? double.infinity,
//           height: widget.height ?? 400,
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: TableCalendar(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             calendarFormat: CalendarFormat.month,
//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//               titleTextStyle:
//                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             calendarBuilders: CalendarBuilders(
//               defaultBuilder: (context, date, _) {
//                 final emotionRecord = FFAppState().monthlyEmotions.firstWhere(
//                       (entry) =>
//                           entry.timeRecord != null &&
//                           entry.timeRecord!.year == date.year &&
//                           entry.timeRecord!.month == date.month &&
//                           entry.timeRecord!.day == date.day,
//                       orElse: () => EmotionDayStruct(),
//                     );
//                 String iconUrl = getEmotionIconUrl(emotionRecord.emotion ?? 0);
//                 return Center(
//                   child: iconUrl.isNotEmpty
//                       ? Image.network(iconUrl, height: 24, width: 24)
//                       : Text(date.day.toString(),
//                           style: TextStyle(fontSize: 16)),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CustomCalendar2 extends StatefulWidget {
//   const CustomCalendar2({
//     super.key,
//     this.width,
//     this.height,
//   });

//   final double? width;
//   final double? height;

//   @override
//   State<CustomCalendar2> createState() => _CustomCalendar2State();
// }

// class _CustomCalendar2State extends State<CustomCalendar2> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   double? _averageEmotion;

//   Map<int, String> _emotionIcons = {
//     1: "😢", // Очень плохое
//     2: "😞", // Плохое
//     3: "😐", // Нейтральное
//     4: "😊", // Хорошее
//     5: "😃" // Отличное
//   };

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _calculateAverageEmotion() async {
//     if (_startDate == null || _endDate == null) return;
//     final emotionsRef = FirebaseFirestore.instance.collection('emotions');
//     final snapshot = await emotionsRef
//         .where('timeRecord', isGreaterThanOrEqualTo: _startDate)
//         .where('timeRecord', isLessThanOrEqualTo: _endDate)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       setState(() {
//         _averageEmotion = null;
//       });
//       return;
//     }

//     double total = 0;
//     int count = 0;
//     for (var doc in snapshot.docs) {
//       int? emotionValue = doc['emotionValue'];
//       if (emotionValue != null) {
//         total += emotionValue;
//         count++;
//       }
//     }

//     setState(() {
//       _averageEmotion = total / count;
//     });
//   }

//   String getEmojiForAverageEmotion() {
//     if (_averageEmotion == null) return "❓";
//     int roundedEmotion = _averageEmotion!.round().clamp(1, 5);
//     return _emotionIcons[roundedEmotion] ?? "❓";
//   }

//   void _selectDate(BuildContext context, bool isStartDate) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStartDate
//           ? _startDate ?? DateTime.now()
//           : _endDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStartDate) {
//           _startDate = picked;
//         } else {
//           _endDate = picked;
//         }
//       });
//       _calculateAverageEmotion();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () => _selectDate(context, true),
//               child: Text(_startDate == null
//                   ? "Choose start date"
//                   : "Start: ${_startDate!.toLocal()}".split(' ')[0]),
//             ),
//             ElevatedButton(
//               onPressed: () => _selectDate(context, false),
//               child: Text(_endDate == null
//                   ? "Choose and date"
//                   : "End: ${_endDate!.toLocal()}".split(' ')[0]),
//             ),
//           ],
//         ),
//         if (_averageEmotion != null)
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Text("Average emotion: ${getEmojiForAverageEmotion()}",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//         Container(
//           width: widget.width ?? double.infinity,
//           height: widget.height ?? 400,
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: TableCalendar(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _focusedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: (selectedDay, focusedDay) {
//               setState(() {
//                 _selectedDay = selectedDay;
//                 _focusedDay = focusedDay;
//               });
//             },
//             calendarFormat: CalendarFormat.month,
//             headerStyle: HeaderStyle(
//               formatButtonVisible: false,
//               titleCentered: true,
//               titleTextStyle:
//                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCalendar2 extends StatefulWidget {
  const CustomCalendar2({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<CustomCalendar2> createState() => _CustomCalendar2State();
}

class _CustomCalendar2State extends State<CustomCalendar2> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _startDate;
  DateTime? _endDate;
  double? _averageEmotion;

  Map<int, String> _emotionIcons = {
    1: "😢", // Очень плохое
    2: "😞", // Плохое
    3: "😐", // Нейтральное
    4: "😊", // Хорошее
    5: "😃" // Отличное
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _calculateAverageEmotion() async {
    if (_startDate == null || _endDate == null) return;
    final emotionsRef = FirebaseFirestore.instance.collection('emotions');
    final snapshot = await emotionsRef
        .where('timeRecord', isGreaterThanOrEqualTo: _startDate)
        .where('timeRecord', isLessThanOrEqualTo: _endDate)
        .get();

    if (snapshot.docs.isEmpty) {
      setState(() {
        _averageEmotion = null;
      });
      return;
    }

    double total = 0;
    int count = 0;
    for (var doc in snapshot.docs) {
      int? emotionValue = doc['emotionValue'];
      if (emotionValue != null) {
        total += emotionValue;
        count++;
      }
    }

    setState(() {
      _averageEmotion = total / count;
    });
  }

  String getEmojiForAverageEmotion() {
    if (_averageEmotion == null) return "❓";
    int roundedEmotion = _averageEmotion!.round().clamp(1, 5);
    return _emotionIcons[roundedEmotion] ?? "❓";
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? _startDate ?? DateTime.now()
          : _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _calculateAverageEmotion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context, true),
              child: Text(_startDate == null
                  ? "Choose start date"
                  : "Start: ${_startDate!.toLocal()}".split(' ')[0]),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context, false),
              child: Text(_endDate == null
                  ? "Choose end date"
                  : "End: ${_endDate!.toLocal()}".split(' ')[0]),
            ),
          ],
        ),
        if (_averageEmotion != null)
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Average emotion: ${getEmojiForAverageEmotion()}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        Container(
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
              titleTextStyle:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final emotionRecord = FFAppState().monthlyEmotions.firstWhere(
                      (entry) =>
                          entry.timeRecord != null &&
                          entry.timeRecord!.year == date.year &&
                          entry.timeRecord!.month == date.month &&
                          entry.timeRecord!.day == date.day,
                      orElse: () => EmotionDayStruct(),
                    );
                String emoji = _emotionIcons[emotionRecord.emotion ?? 0] ??
                    date.day.toString();
                return Center(
                  child: Text(emoji, style: TextStyle(fontSize: 16)),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
