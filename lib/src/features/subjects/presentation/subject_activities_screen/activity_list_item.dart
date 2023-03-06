import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/activity.dart';
import 'package:starter_architecture_flutter_firebase/src/features/subjects/domain/subject.dart';

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({
    super.key,
    required this.activity,
    required this.subject,
    this.onTap,
  });

  final Activity activity;
  final Subject subject;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    // final dayOfWeek = Format.dayOfWeek(activity.start);
    // final startDate = Format.date(activity.start);
    // final startTime = TimeOfDay.fromDateTime(activity.start).format(context);
    // final endTime = TimeOfDay.fromDateTime(activity.end).format(context);
    // final durationFormatted = Format.hours(activity.durationInHours);

    // final pay = job.ratePerHour * entry.durationInHours;
    // final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Row(children: <Widget>[
        //   Text(dayOfWeek,
        //       style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
        //   const SizedBox(width: 15.0),
        //   Text(startDate, style: const TextStyle(fontSize: 18.0)),
        //   if (job.ratePerHour > 0.0) ...<Widget>[
        //     Expanded(child: Container()),
        //     Text(
        //       payFormatted,
        //       style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
        //     ),
        //   ],
        // ]),
        // Row(children: <Widget>[
        //   Text('$startTime - $endTime', style: const TextStyle(fontSize: 16.0)),
        //   Expanded(child: Container()),
        //   Text(durationFormatted, style: const TextStyle(fontSize: 16.0)),
        // ]),
        if (activity.title.isNotEmpty)
          Text(
            activity.title,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleActivityListItem extends StatelessWidget {
  const DismissibleActivityListItem({
    super.key,
    required this.dismissibleKey,
    required this.activity,
    required this.subject,
    this.onDismissed,
    this.onTap,
  });

  final Key dismissibleKey;
  final Activity activity;
  final Subject subject;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed?.call(),
      child: ActivityListItem(
        activity: activity,
        subject: subject,
        onTap: onTap,
      ),
    );
  }
}
