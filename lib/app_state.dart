import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _monthlyEmotions = prefs
              .getStringList('ff_monthlyEmotions')
              ?.map((x) {
                try {
                  return EmotionDayStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _monthlyEmotions;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<EmotionDayStruct> _monthlyEmotions = [];
  List<EmotionDayStruct> get monthlyEmotions => _monthlyEmotions;
  set monthlyEmotions(List<EmotionDayStruct> value) {
    _monthlyEmotions = value;
    prefs.setStringList(
        'ff_monthlyEmotions', value.map((x) => x.serialize()).toList());
  }

  void addToMonthlyEmotions(EmotionDayStruct value) {
    monthlyEmotions.add(value);
    prefs.setStringList('ff_monthlyEmotions',
        _monthlyEmotions.map((x) => x.serialize()).toList());
  }

  void removeFromMonthlyEmotions(EmotionDayStruct value) {
    monthlyEmotions.remove(value);
    prefs.setStringList('ff_monthlyEmotions',
        _monthlyEmotions.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMonthlyEmotions(int index) {
    monthlyEmotions.removeAt(index);
    prefs.setStringList('ff_monthlyEmotions',
        _monthlyEmotions.map((x) => x.serialize()).toList());
  }

  void updateMonthlyEmotionsAtIndex(
    int index,
    EmotionDayStruct Function(EmotionDayStruct) updateFn,
  ) {
    monthlyEmotions[index] = updateFn(_monthlyEmotions[index]);
    prefs.setStringList('ff_monthlyEmotions',
        _monthlyEmotions.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMonthlyEmotions(int index, EmotionDayStruct value) {
    monthlyEmotions.insert(index, value);
    prefs.setStringList('ff_monthlyEmotions',
        _monthlyEmotions.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
