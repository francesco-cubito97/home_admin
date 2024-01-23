import 'package:flutter/material.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';
import 'package:home_adm/components/shopping_item.dart';
import 'package:home_adm/components/nested_lists.dart';

import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/database/database_manager.dart' as db;

// I should create a list of elements setted as not present inside the deposit.

// It is really similar to the deposit with the difference that it receives the
// list of elements that must be bought from the deposit and permits to unmark
// them during shopping.

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<DepositItemModel> sideboardList = [];
  List<DepositItemModel> freshfoodList = [];
  List<DepositItemModel> refrigeratorList = [];
  List<DepositItemModel> freezerList = [];
  List<DepositItemModel> otherItemsList = [];

  bool loading = true;

  List<DepositItemModel> itemsToSave = [];

  void _refreshData({bool refreshAll = false}) async {
    final data = await db.getNotPresentItems();

    if (refreshAll) {
      List<DepositItemModel> temporarySideboardList = [];
      List<DepositItemModel> temporaryFreshFoodList = [];
      List<DepositItemModel> temporaryRefrigeratorList = [];
      List<DepositItemModel> temporaryFreezerList = [];
      List<DepositItemModel> temporaryOtherItemsList = [];

      for (DepositItemModel item in data) {
        // Add it to the correct list
        switch (item.location) {
          case constants.freezerListIndex:
            temporaryFreezerList.add(item);
            break;
          case constants.sideboardListIndex:
            temporarySideboardList.add(item);
            break;
          case constants.freshFoodListIndex:
            temporaryFreshFoodList.add(item);
            break;
          case constants.refrigeratorListIndex:
            temporaryRefrigeratorList.add(item);
            break;
          case constants.otherItemsListIndex:
            temporaryOtherItemsList.add(item);
            break;
          default:
        }

        // And update the state to refresh the page
        setState(() {
          freezerList = temporaryFreezerList;
          refrigeratorList = temporaryRefrigeratorList;
          freshfoodList = temporaryFreshFoodList;
          sideboardList = temporarySideboardList;
          otherItemsList = temporaryOtherItemsList;
        });
      }
    }

    setState(() {
      loading = !loading;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(refreshAll: true);
  }

  List<DepositItemModel> getItemListByIndex(int listIndex) {
    switch (listIndex) {
      case constants.freezerListIndex:
        return freezerList;
      case constants.refrigeratorListIndex:
        return refrigeratorList;
      case constants.freshFoodListIndex:
        return freshfoodList;
      case constants.sideboardListIndex:
        return sideboardList;
      case constants.otherItemsListIndex:
        return otherItemsList;

      default:
        return [];
    }
  }

  void _removeItemsFromList(List<DepositItemModel> itemsToRemove) {
    
    for(DepositItemModel itemToRemove in itemsToRemove) {
      switch (itemToRemove.location) {
      case constants.freezerListIndex:
        freezerList.remove(itemToRemove);
        break;

      case constants.refrigeratorListIndex:
        refrigeratorList.remove(itemToRemove);
        break;

      case constants.freshFoodListIndex:
        freshfoodList.remove(itemToRemove);
        break;

      case constants.sideboardListIndex:
        sideboardList.remove(itemToRemove);
        break;

      case constants.otherItemsListIndex:
        otherItemsList.remove(itemToRemove);
        break;

      default:
    }
    }
    
  }

  void _toggleItemPresence(DepositItemModel item) async {
    item.isPresent = (item.isPresent + 1) % 2;

    // Insert in the list of elements to save
    if(item.isPresent != 0 && !itemsToSave.contains(item))
    {
      setState(() {
        itemsToSave.add(item);
      });
    }
    else if(item.isPresent == 0 && itemsToSave.contains(item))
    {
      setState(() {
        itemsToSave.remove(item);
      });
    }

    // Update the value on the database
    //await db.updateItemPresence(item);

  }

  void saveAndClean() async {
    // Update the values on database
    await db.updateMultipleItemPresence(itemsToSave);

    _removeItemsFromList(itemsToSave);
    
    setState(() {
      itemsToSave = [];
    });

    _refreshData(refreshAll: true);
  }

  @override
  Widget build(BuildContext context) {
    void Function()? onSavePressedFunction = itemsToSave.isNotEmpty ? saveAndClean : null;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          title: Text(
              constants.shoppingCartPageTitle[constants.selectedLanguage])),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            NestedList(
                itemListTitle: constants
                    .listDepositTypeSideboard[constants.selectedLanguage],
                itemsWidget: getItemListByIndex(constants.sideboardListIndex)
                    .map((DepositItemModel item) => ShoppingItem(
                        item: item, onItemStateChanged: _toggleItemPresence))
                    .toList()),
            NestedList(
                itemListTitle: constants
                    .listDepositTypeFreezer[constants.selectedLanguage],
                itemsWidget: getItemListByIndex(constants.freezerListIndex)
                    .map((DepositItemModel item) => ShoppingItem(
                        item: item, onItemStateChanged: _toggleItemPresence))
                    .toList()),
            NestedList(
                itemListTitle: constants
                    .listDepositTypeRefrigerator[constants.selectedLanguage],
                itemsWidget: getItemListByIndex(constants.refrigeratorListIndex)
                    .map((DepositItemModel item) => ShoppingItem(
                        item: item, onItemStateChanged: _toggleItemPresence))
                    .toList()),
            NestedList(
                itemListTitle: constants
                    .listDepositTypeFreshFoods[constants.selectedLanguage],
                itemsWidget: getItemListByIndex(constants.freshFoodListIndex)
                    .map((DepositItemModel item) => ShoppingItem(
                        item: item, onItemStateChanged: _toggleItemPresence))
                    .toList()),
            NestedList(
                itemListTitle:
                    constants.listDepositTypeOther[constants.selectedLanguage],
                itemsWidget: getItemListByIndex(constants.otherItemsListIndex)
                    .map((DepositItemModel item) => ShoppingItem(
                        item: item, onItemStateChanged: _toggleItemPresence))
                    .toList()),
            SizedBox(height: 100.0)
          ])),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary
          ),
          
          onPressed: onSavePressedFunction,
          child: Text(
            constants.saveBuyiedItemsButton[constants.selectedLanguage],
            style: TextStyle(fontSize: 25),
          ),
      )
    );
  }
}
