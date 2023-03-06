import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/strings.dart';
import 'package:starter_architecture_flutter_firebase/src/features/activities/domain/activities_list_tile_model.dart';
import 'package:starter_architecture_flutter_firebase/src/features/activities/application/activities_service.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/list_items_builder.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.subject),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final entriesTileModelStream =
              ref.watch(entriesTileModelStreamProvider);
          return ListItemsBuilder<ActivitiesListTileModel>(
            data: entriesTileModelStream,
            itemBuilder: (context, model) => ActivitiesListTile(model: model),
          );
        },
      ),
    );
  }
}

class ActivitiesListTile extends StatelessWidget {
  const ActivitiesListTile({super.key, required this.model});
  final ActivitiesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    return Container(
      color: model.isHeader ? Colors.indigo[100] : null,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(model.leadingText, style: const TextStyle(fontSize: fontSize)),
          Expanded(child: Container()),
          if (model.middleText != null)
            Text(
              model.middleText!,
              style: TextStyle(color: Colors.green[700], fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          SizedBox(
            width: 60.0,
            child: Text(
              model.trailingText,
              style: const TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
