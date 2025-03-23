import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmotionRecord extends FirestoreRecord {
  EmotionRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "emotionValue" field.
  int? _emotionValue;
  int get emotionValue => _emotionValue ?? 0;
  bool hasEmotionValue() => _emotionValue != null;

  // "emotionIcon" field.
  String? _emotionIcon;
  String get emotionIcon => _emotionIcon ?? '';
  bool hasEmotionIcon() => _emotionIcon != null;

  // "icon" field.
  String? _icon;
  String get icon => _icon ?? '';
  bool hasIcon() => _icon != null;

  void _initializeFields() {
    _emotionValue = castToType<int>(snapshotData['emotionValue']);
    _emotionIcon = snapshotData['emotionIcon'] as String?;
    _icon = snapshotData['icon'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('emotion');

  static Stream<EmotionRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EmotionRecord.fromSnapshot(s));

  static Future<EmotionRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EmotionRecord.fromSnapshot(s));

  static EmotionRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EmotionRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EmotionRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EmotionRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EmotionRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EmotionRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEmotionRecordData({
  int? emotionValue,
  String? emotionIcon,
  String? icon,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'emotionValue': emotionValue,
      'emotionIcon': emotionIcon,
      'icon': icon,
    }.withoutNulls,
  );

  return firestoreData;
}

class EmotionRecordDocumentEquality implements Equality<EmotionRecord> {
  const EmotionRecordDocumentEquality();

  @override
  bool equals(EmotionRecord? e1, EmotionRecord? e2) {
    return e1?.emotionValue == e2?.emotionValue &&
        e1?.emotionIcon == e2?.emotionIcon &&
        e1?.icon == e2?.icon;
  }

  @override
  int hash(EmotionRecord? e) =>
      const ListEquality().hash([e?.emotionValue, e?.emotionIcon, e?.icon]);

  @override
  bool isValidKey(Object? o) => o is EmotionRecord;
}
