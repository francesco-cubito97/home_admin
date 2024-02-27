import 'package:flutter/material.dart';
import 'package:home_adm/components/deposit_item.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';
import 'package:home_adm/database/data_models/recipe_item_model.dart';

import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/components/nested_lists.dart';
import 'package:home_adm/components/popup_menu.dart';

import 'package:home_adm/database/database_manager.dart' as db;
// This will be the list of lists of elements inside the deposit

// There will be a list for each of the following bullet:
//    - Freezer
//    - Refrigeretor
//    - Sideboard
//    - Fresh foods

class DepositPage extends StatefulWidget {
  // Constructor
  const DepositPage({super.key});

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  
  // Popup menu settings
  Map<String, int> popupMenuItemNames = constants.getDepositPopupMenu(constants.PopupMenuItem.mainView.index);

  int depositPageType = -1;

  // List containing all the lists
  List<DepositItemModel> sideboardList = [];
  List<DepositItemModel> freshfoodList = [];
  List<DepositItemModel> refrigeratorList = [];
  List<DepositItemModel> freezerList = [];
  List<DepositItemModel> otherItemsList = [];

  bool loading = true;
  bool deleteItemsViewSelected = false;

  // List of items must be deleted
  List<DepositItemModel> itemsToDelete = [];

  void _refreshData({bool refreshAll = false}) async {
    final data = await db.getItems();

    

    // Insert elements inside the correct lists
    if (refreshAll) {
      List<DepositItemModel> sideboard = [];
      List<DepositItemModel> freshfood = [];
      List<DepositItemModel> refrigerator = [];
      List<DepositItemModel> freezer = [];
      List<DepositItemModel> otherItems = [];

      for (var element in data) {
        switch (element.location) {
          case constants.freezerListIndex:
            freezer.add(element);
            break;
          case constants.refrigeratorListIndex:
            refrigerator.add(element);
            break;
          case constants.freshFoodListIndex:
            freshfood.add(element);
            break;
          case constants.sideboardListIndex:
            sideboard.add(element);
            break;
          case constants.otherItemsListIndex:
            otherItems.add(element);
            break;

          default:
            break;
        }
      }

      setState(() {
        sideboardList = sideboard;
        freezerList = freezer;
        refrigeratorList = refrigerator;
        freshfoodList = freshfood;
        otherItemsList = otherItems;
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(refreshAll: true);
  }

  int getItemListIndexByName(String listName) {
    int result = -1;

    if (constants.allDepositLists[constants.selectedLanguage].contains(listName)) {
      return constants.allDepositLists[constants.selectedLanguage]
          .indexOf(listName);
    } 

    return result;
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

  void _addItemToItemListByIndex(int listIndex, DepositItemModel itemModel) {
    switch (listIndex) {
      case constants.freezerListIndex:
        setState(() {
          freezerList.add(itemModel);
        });
        break;
      case constants.refrigeratorListIndex:
        setState(() {
          refrigeratorList.add(itemModel);
        });
        break;
      case constants.freshFoodListIndex:
        setState(() {
          freshfoodList.add(itemModel);
        });
        break;
      case constants.sideboardListIndex:
        setState(() {
          sideboardList.add(itemModel);
        });
        break;
      case constants.otherItemsListIndex:
        setState(() {
          otherItemsList.add(itemModel);
        });
        break;

      default:
        break;
    }
  }

  void updateList(DepositItemModel updatedItem) {
    
    switch (updatedItem.location) {
      case constants.freezerListIndex:
        int index = freezerList.indexWhere((item) => item.itemID == updatedItem.itemID);
        setState(() {
          freezerList.elementAt(index).isPresent = updatedItem.isPresent;
        });
        break;
      case constants.refrigeratorListIndex:
      int index = refrigeratorList.indexWhere((item) => item.itemID == updatedItem.itemID);
        setState(() {
          refrigeratorList.elementAt(index).isPresent = updatedItem.isPresent;
        });
        break;
      case constants.freshFoodListIndex:
      int index = freshfoodList.indexWhere((item) => item.itemID == updatedItem.itemID);
        setState(() {
          freshfoodList.elementAt(index).isPresent = updatedItem.isPresent;
        });
        break;
      case constants.sideboardListIndex:
      int index = sideboardList.indexWhere((item) => item.itemID == updatedItem.itemID);
        setState(() {
          sideboardList.elementAt(index).isPresent = updatedItem.isPresent;
        });
        break;
      case constants.otherItemsListIndex:
      int index = otherItemsList.indexWhere((item) => item.itemID == updatedItem.itemID);
        setState(() {
          otherItemsList.elementAt(index).isPresent = updatedItem.isPresent;
        });
        break;

      default:
        break;
    }
  
  }

  void _toggleDepositItemPresence(DepositItemModel item) async {
    item.isPresent = (item.isPresent + 1) % 2;

    // Update the value on the database
    int countUpdated = await db.updateItemPresence(item);

    updateList(item);
  }

  // Function to decide what item to delete
  void _toggleDepositItemSelection(DepositItemModel item) {
    item.selected = !item.selected;

    if(item.selected && !itemsToDelete.contains(item))
    {
      setState(() {
        itemsToDelete.add(item);
      });
    }
    else if(!item.selected && itemsToDelete.contains(item))
    {
      setState(() {
        itemsToDelete.remove(item);
      });
    }   
  }

  void saveAndDelete() async {
    // Delete items from the database
    await db.deleteItems(itemsToDelete);

    // Set the simple view
    setState(() {
        deleteItemsViewSelected = false;
        popupMenuItemNames = constants.getDepositPopupMenu(constants.PopupMenuItem.mainView.index);
        itemsToDelete = [];
    });

    // Refresh everything
    _refreshData(refreshAll: true);
  }


  void addNewItem(FormResult itemToAdd) async {
    int listIndex = getItemListIndexByName(itemToAdd.choosenDepositList);
    String itemName = itemToAdd.choosenItemName;

    DepositItemModel newItem = 
      DepositItemModel(
        name: itemName, 
        location: listIndex, 
        isPresent: 1
      );

    newItem.setID(await db.insertNewItem(newItem));

    _addItemToItemListByIndex(listIndex, newItem);
  }

  void updatePage(int index) async {
    
    if(index == constants.PopupMenuItem.addNewItemView.index) {
      final FormResult? newItem = await openDepositDialog();
          if (newItem == null ||
              newItem.choosenItemName.isEmpty ||
              newItem.choosenDepositList.isEmpty) return;

          // Add the new created item to the correspondent list
          addNewItem(newItem);
    }

    else if(index == constants.PopupMenuItem.deleteItemsView.index) {
      setState(() {
        deleteItemsViewSelected = true;
        popupMenuItemNames = constants.getDepositPopupMenu(index);
      });
    }

    else if(index == constants.PopupMenuItem.listItemsView.index) {
      setState(() {
        deleteItemsViewSelected = false;
        popupMenuItemNames = constants.getDepositPopupMenu(index);
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Simple list view to add element in the shopping page
    if(deleteItemsViewSelected == false) {

      return Scaffold(
        backgroundColor: theme.colorScheme.primary,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,

          title: Text(constants.depositPageTitle[constants.selectedLanguage]),
          actions: <Widget>[
            PopupMenu(popupMenuItemsNames: popupMenuItemNames, popupMenuCallback: (itemIndex) => updatePage(itemIndex))
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeSideboard[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.sideboardListIndex)
                      .map((DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemPresence))
                      .toList()),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeFreezer[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.freezerListIndex)
                      .map((DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemPresence))
                      .toList()),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeRefrigerator[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.refrigeratorListIndex)
                      .map((DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemPresence))
                      .toList()),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeFreshFoods[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.freshFoodListIndex)
                      .map((DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemPresence))
                      .toList()),
              NestedList(
                  itemListTitle:
                      constants.listDepositTypeOther[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.otherItemsListIndex)
                      .map((DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemPresence))
                      .toList()),
              SizedBox(height: 100.0)
            ])),
          ],
        ),
      );
    }

    // Delete items view
    else {
      void Function()? onDeletePressedFunction = itemsToDelete.isNotEmpty ? saveAndDelete : null;

      return Scaffold(
        backgroundColor: theme.colorScheme.primary,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,

          title: Text(constants.depositPageTitle[constants.selectedLanguage]),
          actions: <Widget>[
            PopupMenu(popupMenuItemsNames: popupMenuItemNames, popupMenuCallback: (itemIndex) => updatePage(itemIndex))
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeSideboard[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.sideboardListIndex)
                      .map(
                        (DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemSelection,
                          deleteView: true,
                        ),
                      )
                      .toList()
              ),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeFreezer[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.freezerListIndex)
                      .map(
                        (DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemSelection,
                          deleteView: true,
                        ),
                      )
                      .toList()
              ),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeRefrigerator[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.refrigeratorListIndex)
                      .map(
                        (DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemSelection,
                          deleteView: true,
                        ),
                      )
                      .toList()
              ),
              NestedList(
                  itemListTitle: constants
                      .listDepositTypeFreshFoods[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.freshFoodListIndex)
                      .map(
                        (DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemSelection,
                          deleteView: true,
                        ),
                      )
                      .toList()
              ),
              NestedList(
                  itemListTitle:
                      constants.listDepositTypeOther[constants.selectedLanguage],
                  itemsWidget: getItemListByIndex(constants.otherItemsListIndex)
                      .map(
                        (DepositItemModel item) => DepositItem(
                          item: item,
                          onItemStateChanged: _toggleDepositItemSelection,
                          deleteView: true,
                        ),
                      )
                      .toList()
              ),
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
          
          onPressed: onDeletePressedFunction,
          child: Text(constants.deleteSelectedItemsButton[constants.selectedLanguage],
          style: TextStyle(fontSize: 25),),
        ),
      );
    }
  }

  // TODO: Externalize this
  Future<FormResult?> openDepositDialog() {
    FormResult formResult = FormResult(choosenItemName: "", 
                                       choosenDepositList: "");

    return showDialog<FormResult>(
      context: context,
      builder: (context) => SingleChildScrollView(
        // This helps the dialog to not be resized after opening keyboard
        child: AlertDialog(
          title: Text(constants.depositDialogTitle[constants.selectedLanguage]),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                constants.depositDialogItemName[constants.selectedLanguage],
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: constants
                        .depositDialogItemNameHint[constants.selectedLanguage]),
                onChanged: (value) {
                  formResult.choosenItemName = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                constants.depositDialogItemLocation[constants.selectedLanguage],
                style: TextStyle(fontSize: 20),
              ),
              DropdownList(
                  listOfOptions:
                      constants.allDepositLists[constants.selectedLanguage],
                  theme: Theme.of(context),
                  onChoosenList: (value) {
                    formResult.choosenDepositList = value;
                  })
            ],
          ),
          actions: [
            TextButton(
              child: Text(constants
                  .depositDialogSubmitButton[constants.selectedLanguage]),
              onPressed: () {
                Navigator.of(context).pop(formResult);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Externalize this
class DropdownList extends StatefulWidget {
  const DropdownList(
      {super.key,
      required this.listOfOptions,
      required this.theme,
      required this.onChoosenList});

  final List<String> listOfOptions;
  final ThemeData theme;

  final Function(String) onChoosenList;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  String? dropdownValue;

  Color? underlineColor;

  @override
  void initState() {
    super.initState();

    underlineColor = widget.theme.disabledColor;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text("Choose a value"),
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 2,
        color: underlineColor,
      ),
      onChanged: (String? value) {
        widget.onChoosenList(value!);

        setState(() {
          dropdownValue = value;
          underlineColor = widget.theme.primaryColor;
        });
      },
      items: widget.listOfOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// TODO: Externalize this

// Every object of this class will contain the result
// deriving from the form
class FormResult {
  String choosenItemName;
  String choosenDepositList;

  FormResult({required this.choosenItemName, required this.choosenDepositList});
}

