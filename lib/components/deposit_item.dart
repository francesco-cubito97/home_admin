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
    final theme = Theme.of(context);
    final color = item.isPresent == 0 ? theme.primaryColor : theme.disabledColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            color: color,
            onPressed: () {
              onItemStateChanged(item);
        }),
        title: Text(
            item.name
        ),
        onTap: () {
          onItemStateChanged(item);
        }
      ),
    );
  }
}