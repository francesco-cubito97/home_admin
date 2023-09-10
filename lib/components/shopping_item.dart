import 'package:flutter/material.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';

// Inside the shopping page there will be checkable elements
class ShoppingItem extends StatelessWidget {
  ShoppingItem({required this.item, required this.onItemStateChanged})
      : super(key: ObjectKey(item));

  final DepositItemModel item;
  final void Function(DepositItemModel) onItemStateChanged;

  @override
  Widget build(BuildContext context) {
    final itemIsPresent = item.isPresent == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Checkbox(
            value: itemIsPresent,
            onChanged: (value) {
              onItemStateChanged(item);
        }),
        title: Text(
            item.name,
            style: TextStyle(decoration: (itemIsPresent ? TextDecoration.lineThrough : null))
        ),
        onTap: () {
          onItemStateChanged(item);
        }
      ),
    );
  }
}