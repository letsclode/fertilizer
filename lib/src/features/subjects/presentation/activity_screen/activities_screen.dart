import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/data/firestore_repository.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/presentation/activity_screen/activity_screen_controller.dart';
import 'package:starter_architecture_flutter_firebase/src/utils/async_value_ui.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen(
      {super.key, required this.subjectId, this.activityId, this.activity});
  final SubjectID subjectId;
  final ActivityID? activityId;
  final Activity? activity;

  @override
  ConsumerState<ActivitiesScreen> createState() => _EntryPageState();
}

class _EntryPageState extends ConsumerState<ActivitiesScreen> {
  late String _title;

  @override
  void initState() {
    super.initState();
    // final start = widget.entry?.start ?? DateTime.now();
    // _startDate = DateTime(start.year, start.month, start.day);
    // _startTime = TimeOfDay.fromDateTime(start);

    // final end = widget.entry?.end ?? DateTime.now();
    // _endDate = DateTime(end.year, end.month, end.day);
    // _endTime = TimeOfDay.fromDateTime(end);

    _title = widget.activity?.title ?? '';
  }

  Activity _entryFromState() {
    // final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
    //     _startTime.hour, _startTime.minute);
    // final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
    //     _endTime.hour, _endTime.minute);
    final id = widget.activity?.id ?? documentIdFromCurrentDate();
    return Activity(id: id, subjectId: widget.subjectId, title: _title);
  }

  Future<void> _setEntryAndDismiss() async {
    final activity = _entryFromState();
    final success = await ref
        .read(entryScreenControllerProvider.notifier)
        .setEntry(activity);
    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      entryScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity != null ? 'Edit Activity' : 'New Activity'),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.activity != null ? 'Update' : 'Create',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // _buildStartDate(),
              // _buildEndDate(),
              // const SizedBox(height: 8.0),
              // _buildDuration(),
              const SizedBox(height: 8.0),
              _buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStartDate() {
  //   return DateTimePicker(
  //     labelText: 'Start',
  //     selectedDate: _startDate,
  //     selectedTime: _startTime,
  //     onSelectedDate: (date) => setState(() => _startDate = date),
  //     onSelectedTime: (time) => setState(() => _startTime = time),
  //   );
  // }

  // Widget _buildEndDate() {
  //   return DateTimePicker(
  //     labelText: 'End',
  //     selectedDate: _endDate,
  //     selectedTime: _endTime,
  //     onSelectedDate: (date) => setState(() => _endDate = date),
  //     onSelectedTime: (time) => setState(() => _endTime = time),
  //   );
  // }

  // Widget _buildDuration() {
  //   final currentEntry = _entryFromState();
  //   // final durationFormatted = Format.hours(currentEntry.durationInHours);
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Text(
  //         'Duration: $durationFormatted',
  //         style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
  //         maxLines: 1,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildTitle() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _title),
      decoration: const InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      keyboardAppearance: Brightness.light,
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (title) => _title = title,
    );
  }
}
