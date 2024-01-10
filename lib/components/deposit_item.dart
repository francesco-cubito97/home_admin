import 'package:flutter/material.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';

// Inside the deposit there will be a checkable element
class DepositItem extends StatelessWidget {
  DepositItem({required this.item, required this.onItemStateChanged, this.deleteView = false})
      : super(key: ObjectKey(item));

  final DepositItemModel item;
  final void Function(DepositItemModel) onItemStateChanged;
  final bool deleteView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = item.isPresent == 0 ? theme.primaryColorLight : theme.cardColor;
    final deleteIconBackgroundColor = item.selected == true ? theme.primaryColor : theme.cardColor;
    final deleteIcon = item.selected == true ? Icons.check_box_outlined : Icons.check_box_outline_blank;

    if(deleteView) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: Checkbox (
              value: item.selected, 
              onChanged: (bool? value) {
                onItemStateChanged(item);
              },
            ),
          title: Text(
              item.name
          ),
          onTap: () {
            onItemStateChanged(item);
          }
        ),
      );
      
    }
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: IconButton(
              icon: Icon(Icons.add_shopping_cart),

              style: IconButton.styleFrom(
                // Associate a different Background color based on the state
                backgroundColor: backgroundColor, 
              ),
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
}

// Is necessary to crete a new component because the button
// checkbox must have its own information on what delete.
// There are two possibilities:
//  - I include in the data model the information of what to delete
//  - I share the information of item IDs that must be deleted.
// Results clear to me that the function to decide what delete or not must
// be external to this child. There I will create the list of items
// that must be deleted.