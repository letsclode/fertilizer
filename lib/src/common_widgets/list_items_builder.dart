import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_architecture_flutter_firebase/src/common_widgets/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.data,
    required this.itemBuilder,
  }) : super(key: key);
  final AsyncValue<List<T>> data;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final gridViewKey = GlobalKey();
    return data.when(
      data: (items) => items.isNotEmpty
          ?
          //  ListView.separated(
          //     itemCount: items.length + 2,
          //     separatorBuilder: (context, index) => const Divider(height: 0.5),
          //     itemBuilder: (context, index) {
          //       if (index == 0 || index == items.length + 1) {
          //         return const SizedBox.shrink();
          //       }
          //       return itemBuilder(context, items[index - 1]);
          //     },
          //   )

          Padding(
              padding: const EdgeInsets.all(15.0),
              child: ReorderableBuilder(
                  scrollController: scrollController,
                  onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
                    for (final orderUpdateEntity in orderUpdateEntities) {
                      final fruit = items.removeAt(orderUpdateEntity.oldIndex);
                      items.insert(orderUpdateEntity.newIndex, fruit);
                    }
                  },
                  builder: (children) {
                    return GridView(
                      key: gridViewKey,
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 8,
                      ),
                      children: children,
                    );
                  },
                  children: List.generate(items.length,
                      (index) => itemBuilder(context, items[index]))),
            )
          : const EmptyContent(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      ),
    );
  }
}
