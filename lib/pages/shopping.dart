import 'package:flutter/material.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';


// I should create a list of elements setted as not present inside the deposit.

// It is really similar to the deposit with the difference that it receives the
// list of elements that must be bought from the deposit and permits to unmark
// them during shopping.

class ShoppingItem extends StatelessWidget {
  final DepositItemModel item;
  final void Function(DepositItemModel) onItemStateChanged;
  
  ShoppingItem({ 
                  required this.item, 
                  required this.onItemStateChanged 
              }) : super(key: ObjectKey(item));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            value: item.isPresent == 1 ? true : false, 
            onChanged: ((value) {
              onItemStateChanged(item);
            }),
          ),
          Text(
              style: TextStyle(decoration: item.isPresent == 0 ? TextDecoration.lineThrough : null),
              item.name,
              
            )
        ],
      ),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  
  List<DepositItemModel> freezer = [];

  void _handleShoppingStateChanged(DepositItemModel item)
  {
    setState(() {
      item.isPresent = (item.isPresent+1)%2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List")
      ),
      body: ListView(
        children: freezer.map((DepositItemModel item) {
            return ShoppingItem(item: item, onItemStateChanged: _handleShoppingStateChanged);
          }).toList()
      )
    );
  }
}