import 'package:flutter/material.dart';

import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/components/calendar_card.dart';

import '../components/popup_menu.dart';

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
    );
  }
}