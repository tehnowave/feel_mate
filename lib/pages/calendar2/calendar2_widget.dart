import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calendar2_model.dart';
export 'calendar2_model.dart';

class Calendar2Widget extends StatefulWidget {
  const Calendar2Widget({super.key});

  static String routeName = 'Calendar2';
  static String routePath = '/calendar2';

  @override
  State<Calendar2Widget> createState() => _Calendar2WidgetState();
}

class _Calendar2WidgetState extends State<Calendar2Widget> {
  late Calendar2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Calendar2Model());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.result = await queryEmotionsRecordOnce(
        queryBuilder: (emotionsRecord) => emotionsRecord
            .where(
              'userRef',
              isEqualTo: currentUserReference,
            )
            .orderBy('timeRecord', descending: true),
      );
      FFAppState().monthlyEmotions = functions
          .fetchEmotion(_model.result!.toList())
          .toList()
          .cast<EmotionDayStruct>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Calendar',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                custom_widgets.CustomCalendar2(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
