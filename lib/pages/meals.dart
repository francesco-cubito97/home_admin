import 'package:flutter/material.dart';

import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/components/calendar_card.dart';

import '../components/popup_menu.dart';
import '../database/data_models/recipe_item_model.dart';
import '../database/database_manager.dart' as db;

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {

  int currentView = constants.PopupMenuItem.mainView.index;
  Map<String, int> popupMenuItems = constants.getMealsPopupMenu(constants.PopupMenuItem.mainView.index);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  void updatePage(int viewIndex) {}

  void loadDate () async {
    final data = await db.getItems();
    final List<int> ingredientsToInsert = [];
    data.forEach((element) { ingredientsToInsert.add(element.itemID); });

    RecipeItemModel newRecipe = RecipeItemModel(name: "Pollo Fritto", ingredients: ingredientsToInsert);
    await db.insertNewRecipe(newRecipe);

    List<RecipeItemModel> recipes = await db.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        title: Text(constants.mealsPageTitle[constants.selectedLanguage]),
        actions: <Widget>[
            PopupMenu(popupMenuItemsNames: popupMenuItems, popupMenuCallback: (viewIndex) => updatePage(viewIndex))
          ],
      ),
      
      body: DayCard(),
      floatingActionButton: FloatingActionButton(onPressed: loadDate),

    );
  }
}