import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EmotionsRecord extends FirestoreRecord {
  EmotionsRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "userRef" field.
  DocumentReference? _userRef;
  DocumentReference? get userRef => _userRef;
  bool hasUserRef() => _userRef != null;

  // "timeRecord" field.
  DateTime? _timeRecord;
  DateTime? get timeRecord => _timeRecord;
  bool hasTimeRecord() => _timeRecord != null;

  // "emotionValue" field.
  int? _emotionValue;
  int get emotionValue => _emotionValue ?? 0;
  bool hasEmotionValue() => _emotionValue != null;

  void _initializeFields() {
    _userRef = snapshotData['userRef'] as DocumentReference?;
    _timeRecord = snapshotData['timeRecord'] as DateTime?;
    _emotionValue = castToType<int>(snapshotData['emotionValue']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('emotions');

  static Stream<EmotionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => EmotionsRecord.fromSnapshot(s));

  static Future<EmotionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => EmotionsRecord.fromSnapshot(s));

  static EmotionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      EmotionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static EmotionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      EmotionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'EmotionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is EmotionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createEmotionsRecordData({
  DocumentReference? userRef,
  DateTime? timeRecord,
  int? emotionValue,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'userRef': userRef,
      'timeRecord': timeRecord,
      'emotionValue': emotionValue,
    }.withoutNulls,
  );

  return firestoreData;
}

class EmotionsRecordDocumentEquality implements Equality<EmotionsRecord> {
  const EmotionsRecordDocumentEquality();

  @override
  bool equals(EmotionsRecord? e1, EmotionsRecord? e2) {
    return e1?.userRef == e2?.userRef &&
        e1?.timeRecord == e2?.timeRecord &&
        e1?.emotionValue == e2?.emotionValue;
  }

  @override
  int hash(EmotionsRecord? e) =>
      const ListEquality().hash([e?.userRef, e?.timeRecord, e?.emotionValue]);

  @override
  bool isValidKey(Object? o) => o is EmotionsRecord;
}
