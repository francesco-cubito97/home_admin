import 'package:flutter/material.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';

// Inside the deposit there will be a checkable element
class DepositItem extends StatelessWidget {
  DepositItem({required this.item, required this.onItemStateChanged})
      : super(key: ObjectKey(item));

  final DepositItemModel item;
  final void Function(DepositItemModel) onItemStateChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Checkbox(
            value: item.isPresent == 0 ? true: false,
            onChanged: (value) {
              onItemStateChanged(item);
        }),
        title: Text(
            item.name,
            style: TextStyle(decoration: (item.isPresent == 0 ? TextDecoration.lineThrough : null))
        ),
        onTap: () {
          onItemStateChanged(item);
        }
      ),
    );
  }
}