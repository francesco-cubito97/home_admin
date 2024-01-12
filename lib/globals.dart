
/// Shared globals
String databaseLocation = "items_database.db";

// List containing the same object in multiple languages:
//    0 - English
//    1 - Italian
enum Languages {eng, ita}

int selectedLanguage = Languages.eng.index;

const List<String> listLanguages = ["English", "Italiano"];

const int freezerListIndex      = 0;
const int refrigeratorListIndex = 1;
const int sideboardListIndex    = 2;
const int freshFoodListIndex    = 3;
const int otherItemsListIndex   = 4;

const int numberOfDepositTypes = 5;

const List<String> listDepositTypeFreezer = ["Freezer", "Congelatore"];
const List<String> listDepositTypeRefrigerator = ["Refrigerator", "Frigorifero"];  
const List<String> listDepositTypeSideboard = ["Sideboard", "Dispensa"]; 
const List<String> listDepositTypeFreshFoods = ["Fresh foods", "Cibi freschi"]; 
const List<String> listDepositTypeOther = ["Other", "Altro"];
const List< List<String> > allLists = [
                                                listDepositTypeFreezer, 
                                                listDepositTypeRefrigerator, 
                                                listDepositTypeSideboard, 
                                                listDepositTypeFreshFoods, 
                                                listDepositTypeOther
                                              ];
const List< List<String> > allDepositLists = [
                                                ["Freezer", "Refrigerator", "Sideboard", "Fresh foods", "Other"],
                                                ["Congelatore", "Frigorifero", "Dispensa", "Cibi freschi", "Altro"]
                                              ];

String getListNameByIndex(int indexOfList)
{
  return allLists[indexOfList][selectedLanguage];
}

enum PopupMenuItem { mainView, addNewItemView, updateItemsView, deleteItemsView, listItemsView }

/// Deposit Page elements
const List<String> depositPageTitle = ["Deposit", "Dispensa"];

const List<String> addDepositItemPopupMenu = ["Add new item", "Aggiungi un elemento"];
const List<String> deleteDepositItemsPopupMenu = ["Delete items", "Elimina elementi"];
const List<String> listDepositItemsPopupMenu = ["List items", "Visualizza elementi"];

const List<String> deleteSelectedItemsButton = ["Delete", "Elimina"];

const List<String> depositDialogTitle = ["Create a new item", "Crea un nuovo elemento"];
const List<String> depositDialogItemName = ["New item name", "Nome del nuovo elemento"];
const List<String> depositDialogItemNameHint = ["Enter name", "Inserisci nome"];
const List<String> depositDialogItemLocation = ["New item location", "Locazione del nuovo elemento"];
const List<String> depositDialogItemLocationHint = ["Choose Location", "Scegli la locazione"];

// Return a map of popup menu item with its index
Map<String, int> getDepositPopupMenu(int currentView) {
  Map<String, int> popupMenuItem = {};

  if(currentView == PopupMenuItem.deleteItemsView.index) {
    popupMenuItem[addDepositItemPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.addNewItemView.index;
    popupMenuItem[listDepositItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.listItemsView.index;
  
  } else if(currentView == PopupMenuItem.listItemsView.index) {
    popupMenuItem[addDepositItemPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.addNewItemView.index;
    popupMenuItem[deleteDepositItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.deleteItemsView.index;
    
  }
  
  return popupMenuItem;
}

const List<String> depositDialogSubmitButton = ["Submit", "Crea"];

/// Shopping Page elements
const List<String> shoppingCartPageTitle = ["Shopping Cart", "Carrello"];
const List<String> saveBuyiedItemsButton = ["Save", "Salva"];


/// Meals Page elements

const List<String> mealsPageTitle = ["Meals schedule", "Pasti giornalieri"];

const List<String> addRecipeItemPopupMenu = ["Add new recipe", "Aggiungi una ricetta"];
const List<String> deleteRecipeItemsPopupMenu = ["Delete recipes", "Elimina ricetta"];
const List<String> listRecipeItemsPopupMenu = ["List recipes", "Visualizza ricette"];

// Return a map of popup menu item with its index
Map<String, int> getMealsPopupMenu(int currentView) {
  Map<String, int> popupMenuItem = {};

  if(currentView == PopupMenuItem.mainView.index) {
    popupMenuItem[listDepositItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.listItemsView.index;
    popupMenuItem[addRecipeItemPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.addNewItemView.index;
    popupMenuItem[deleteRecipeItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.deleteItemsView.index;

  } else if(currentView == PopupMenuItem.deleteItemsView.index) {
    popupMenuItem[addRecipeItemPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.addNewItemView.index;
    popupMenuItem[listDepositItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.listItemsView.index;
  
  } else if(currentView == PopupMenuItem.listItemsView.index) {
    popupMenuItem[addRecipeItemPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.addNewItemView.index;
    popupMenuItem[deleteRecipeItemsPopupMenu.elementAt(selectedLanguage)] = PopupMenuItem.deleteItemsView.index;
    
  }
  
  return popupMenuItem;
}