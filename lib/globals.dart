
String databaseLocation = "items_database.db";

enum Languages {eng, ita}

int selectedLanguage = Languages.eng.index;
  
// List containing the same object in multiple languages:
//    0 - English
//    1 - Italian
const List<String> listLanguages = ["English", "Italiano"];

const String depositPageTitle = "Deposit";
const String shoppingCartPageTitle = "Shopping Cart";

//static const List< List<String> > allPages = [depositPageTitle, shoppingCartPageTitle];

const int depositPageIndex       = 0;
const int shoppingCartPageIndex  = 1;
const int menuPageIndex          = 2;
const int billsPageIndex         = 3;

const int freezerListIndex      = 0;
const int refrigeratorListIndex = 1;
const int sideboardListIndex    = 2;
const int freshFoodListIndex    = 3;
const int otherItemsListIndex   = 4;

const int numberOfDepositTypes = 5;

const List<String> listDepositType1 = ["Freezer", "Congelatore"];
const List<String> listDepositType2 = ["Refrigerator", "Frigorifero"];  
const List<String> listDepositType3 = ["Sideboard", "Dispensa"]; 
const List<String> listDepositType4 = ["Fresh foods", "Cibi freschi"]; 
const List<String> listDepositType5 = ["Other", "Altro"];
const List< List<String> > allLists = [
                                                listDepositType1, 
                                                listDepositType2, 
                                                listDepositType3, 
                                                listDepositType4, 
                                                listDepositType5
                                              ];
const List< List<String> > allDepositLists = [
                                                ["Freezer", "Refrigerator", "Sideboard", "Fresh foods", "Other"],
                                                ["Congelatore", "Frigorifero", "Dispensa", "Cibi freschi", "Altro"]
                                              ];

String getListNameByIndex(int indexOfList)
{
  return allLists[indexOfList][selectedLanguage];
}

// Deposit Page elements
const List<String> addButtonDepositItem = ["Add new item", "Aggiungi un elemento"];
const List<String> depositDialogTitle = ["Create a new item", "Crea un nuovo elemento"];
const List<String> depositDialogItemName = ["New item name", "Nome del nuovo elemento"];
const List<String> depositDialogItemNameHint = ["Enter name", "Inserisci nome"];
const List<String> depositDialogItemLocation = ["New item location", "Locazione del nuovo elemento"];
const List<String> depositDialogItemLocationHint = ["Choose Location", "Scegli la locazione"];

const List<String> depositDialogSubmitButton = ["Submit", "Crea"];