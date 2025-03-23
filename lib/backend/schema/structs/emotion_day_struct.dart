// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmotionDayStruct extends FFFirebaseStruct {
  EmotionDayStruct({
    int? emotion,
    DateTime? timeRecord,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _emotion = emotion,
        _timeRecord = timeRecord,
        super(firestoreUtilData);

  // "emotion" field.
  int? _emotion;
  int get emotion => _emotion ?? 0;
  set emotion(int? val) => _emotion = val;

  void incrementEmotion(int amount) => emotion = emotion + amount;

  bool hasEmotion() => _emotion != null;

  // "timeRecord" field.
  DateTime? _timeRecord;
  DateTime? get timeRecord => _timeRecord;
  set timeRecord(DateTime? val) => _timeRecord = val;

  bool hasTimeRecord() => _timeRecord != null;

  static EmotionDayStruct fromMap(Map<String, dynamic> data) =>
      EmotionDayStruct(
        emotion: castToType<int>(data['emotion']),
        timeRecord: data['timeRecord'] as DateTime?,
      );

  static EmotionDayStruct? maybeFromMap(dynamic data) => data is Map
      ? EmotionDayStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'emotion': _emotion,
        'timeRecord': _timeRecord,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'emotion': serializeParam(
          _emotion,
          ParamType.int,
        ),
        'timeRecord': serializeParam(
          _timeRecord,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static EmotionDayStruct fromSerializableMap(Map<String, dynamic> data) =>
      EmotionDayStruct(
        emotion: deserializeParam(
          data['emotion'],
          ParamType.int,
          false,
        ),
        timeRecord: deserializeParam(
          data['timeRecord'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'EmotionDayStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EmotionDayStruct &&
        emotion == other.emotion &&
        timeRecord == other.timeRecord;
  }

  @override
  int get hashCode => const ListEquality().hash([emotion, timeRecord]);
}

EmotionDayStruct createEmotionDayStruct({
  int? emotion,
  DateTime? timeRecord,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    EmotionDayStruct(
      emotion: emotion,
      timeRecord: timeRecord,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

EmotionDayStruct? updateEmotionDayStruct(
  EmotionDayStruct? emotionDay, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    emotionDay
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addEmotionDayStructData(
  Map<String, dynamic> firestoreData,
  EmotionDayStruct? emotionDay,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (emotionDay == null) {
    return;
  }
  if (emotionDay.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && emotionDay.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final emotionDayData = getEmotionDayFirestoreData(emotionDay, forFieldValue);
  final nestedData = emotionDayData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = emotionDay.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getEmotionDayFirestoreData(
  EmotionDayStruct? emotionDay, [
  bool forFieldValue = false,
]) {
  if (emotionDay == null) {
    return {};
  }
  final firestoreData = mapToFirestore(emotionDay.toMap());

  // Add any Firestore field values
  emotionDay.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getEmotionDayListFirestoreData(
  List<EmotionDayStruct>? emotionDays,
) =>
    emotionDays?.map((e) => getEmotionDayFirestoreData(e, true)).toList() ?? [];
