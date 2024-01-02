import 'package:flutter/material.dart';
import 'package:home_adm/components/deposit_item.dart';
import 'package:home_adm/database/data_models/deposit_item_model.dart';

import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/components/nested_lists.dart';

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
  // List containing all the lists
  List<DepositItemModel> sideboardList = [];
  List<DepositItemModel> freshfoodList = [];
  List<DepositItemModel> refrigeratorList = [];
  List<DepositItemModel> freezerList = [];
  List<DepositItemModel> otherItemsList = [];

  bool loading = true;

  void _refreshData({bool refreshAll = false}) async {
    final data = await db.getItems();
    //print(data);
    //print(refreshAll);
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

    if (constants.allDepositLists[constants.selectedLanguage]
        .contains(listName))
      return constants.allDepositLists[constants.selectedLanguage]
          .indexOf(listName);

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
        freezerList.add(itemModel);
        break;
      case constants.refrigeratorListIndex:
        refrigeratorList.add(itemModel);
        break;
      case constants.freshFoodListIndex:
        freshfoodList.add(itemModel);
        break;
      case constants.sideboardListIndex:
        sideboardList.add(itemModel);
        break;
      case constants.otherItemsListIndex:
        otherItemsList.add(itemModel);
        break;

      default:
        break;
    }
  }

  void _toggleDepositItemPresence(DepositItemModel item) async {
    item.isPresent = (item.isPresent + 1) % 2;

    // Update the value on the database
    await db.updateItemPresence(item);

    // Refresh everything
    _refreshData();
  }

  void addNewItem(FormResult itemToAdd) async {
    int listIndex = getItemListIndexByName(itemToAdd.choosenDepositList);
    String itemName = itemToAdd.choosenItemName;

    DepositItemModel newItem =
        DepositItemModel(name: itemName, location: listIndex, isPresent: 1);

    await db.insertNewItem(newItem);

    _addItemToItemListByIndex(listIndex, newItem);

    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(constants.depositPageTitle[constants.selectedLanguage]),
        actions: <Widget>[MenuAnchorExample()],
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
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final FormResult? newItem = await openDepositDialog();
          if (newItem == null ||
              newItem.choosenItemName.isEmpty ||
              newItem.choosenDepositList.isEmpty) return;

          // Add the new created item to the correspondent list
          addNewItem(newItem);
        },
        child: Text(constants.addButtonDepositItem[constants.selectedLanguage]),
      ),
    );
  }

  Future<FormResult?> openDepositDialog() {
    FormResult formResult =
        FormResult(choosenItemName: "", choosenDepositList: "");

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

// Unificare in un unico widget gli oggetti textfield e dropdownbutton
class DepositForm extends StatefulWidget {
  const DepositForm({super.key});

  @override
  State<DepositForm> createState() => _DepositFormState();
}

class _DepositFormState extends State<DepositForm> {
  // Add a key to the form to make possible, in the future,
  // the validation in the elements of the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Add a controller for each text field
  //final List<TextEditingController> _controllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Please enter some text";

                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text("Submit"))
          ],
        ));
  }
}

// Every object of this class will contain the result
// deriving from the form
class FormResult {
  String choosenItemName;
  String choosenDepositList;

  FormResult({required this.choosenItemName, required this.choosenDepositList});
}

// This is the type used by the menu below.
enum SampleItem { itemOne, itemTwo, itemThree }

class MenuAnchorExample extends StatefulWidget {
  const MenuAnchorExample({super.key});

  @override
  State<MenuAnchorExample> createState() => _MenuAnchorExampleState();
}

class _MenuAnchorExampleState extends State<MenuAnchorExample> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
          tooltip: 'Show menu',
        );
      },
      menuChildren: List<MenuItemButton>.generate(
        3,
        (int index) => MenuItemButton(
          onPressed: () =>
              setState(() => selectedMenu = SampleItem.values[index]),
          child: Text('Item ${index + 1}'),
        ),
      ),
    );
  }
}
