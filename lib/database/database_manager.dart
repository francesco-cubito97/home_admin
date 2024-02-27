import 'package:home_adm/database/data_models/recipe_to_deposit_model.dart';
import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/database/data_models/deposit_item_model.dart';
import 'package:home_adm/database/data_models/recipe_item_model.dart';
// Persistent memory management
import 'package:sqflite/sqflite.dart';
// Disk location management
import 'package:path/path.dart';


Future<Database> getDatabase() async {
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), constants.databaseLocation),

    onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute(
        'CREATE TABLE items(itemID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, location INTEGER, isPresent INTEGER)',
      );

      await db.execute(
        'CREATE TABLE recipes(itemID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, description TEXT)',
      );

      await db.execute(
        '''CREATE TABLE recipe2deposit(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                                       recipeID INTEGER, 
                                       depositID INTEGER, 
                                       FOREIGN KEY(recipeID) REFERENCES recipes(itemID),
                                       FOREIGN KEY(depositID) REFERENCES items(itemID))
        ''',
      );
      
      
      
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}


// Define a function that inserts items into the database
// and returns the new inserted ID
Future<int> insertNewItem(DepositItemModel item) async {
  // Get a reference to the database.
  final db = await getDatabase();

  // Insert the Item into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  return await db.insert(
    'items',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Define a function that inserts items into the database
Future<void> insertNewRecipe(RecipeItemModel recipe) async {
  // Get a reference to the database.
  final db = await getDatabase();

  // Create the recipe
  await db.insert(    
    'recipes',
    recipe.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  // Is necessary save also ingredients 
  // selected from deposit to compose recipe
  if(recipe.ingredients != null) {
    for (int itemID in recipe.ingredients!) {
      RecipeToDepositModel recipeToDeposit = RecipeToDepositModel(recipeID: recipe.itemID, depositID: itemID);

      await db.insert(
        'recipe2deposit',
        recipeToDeposit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  
}

Future<List<DepositItemModel>> getItems() async
{
  final db = await getDatabase();

  // Query the table for all The Items.
  final List<Map<String, dynamic>> maps = await db.query('items', orderBy: "location");

  return List.generate(maps.length, (index) {
    return DepositItemModel(
      itemID: maps[index]["itemID"],
      name: maps[index]["name"],
      location: maps[index]["location"],
      isPresent: maps[index]["isPresent"]
    );
  });
}

Future<List<DepositItemModel>> getItemsByLocation(int location) async
{
  final db = await getDatabase();

  // Query the table for all The Items.
   final List<Map<String, dynamic>> maps = await db.query('items', where: "location = ?", whereArgs: [location]);

  return List.generate(maps.length, (index) {
    return DepositItemModel(
      itemID: maps[index]["itemID"],
      name: maps[index]["name"],
      location: maps[index]["location"],
      isPresent: maps[index]["isPresent"]
    );
  });
}

Future<List<DepositItemModel>> getAllIngredients(int recipeID) async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> mapsIngredients = await db.query('recipe2deposit', where: "recipeID == ?", whereArgs: [recipeID]);

  return List.generate(mapsIngredients.length, (index) => DepositItemModel(
    itemID: mapsIngredients[index]["itemID"], 
    name: mapsIngredients[index]["name"], 
    location: mapsIngredients[index]["location"], 
    isPresent: mapsIngredients[index]["isPresent"])
  );
}

Future<List<RecipeItemModel>> getAllRecipes() async
{
  final db = await getDatabase();

  // Query the table for all The recipes with associated its ingredients
  final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT recipes.*, items.* 
    FROM recipes LEFT JOIN recipe2deposit ON recipes.itemID = recipe2deposit.recipeID 
                 LEFT JOIN items ON recipe2deposit.depositID = items.itemID
  ''');
  
  // Fetch ingredients for each recipe 
  List<List<DepositItemModel>> ingredients = [];
  for(int idx=0; idx<maps.length; ++idx) {
    int recipeId = maps[idx]["recipes.recipeID"];
    if(maps[recipeId]["items.itemID"] != null) {
      ingredients[recipeId].add(DepositItemModel(name: maps[recipeId]["items.itemID"], location: maps[recipeId]["items.location"], isPresent: maps[recipeId]["items.isPresent"]));
    }
  }

  return List.generate(maps.length, (index) {
    return RecipeItemModel(
      itemID: maps[index]["itemID"],
      name: maps[index]["name"],
      description: maps[index]["description"],
    );
  });
}

Future<List<DepositItemModel>> getNotPresentItems() async
{
  final db = await getDatabase();

  // Query the table for all The Items.
  final List<Map<String, dynamic>> maps = await db.query('items', where: "isPresent == 0", orderBy: "location");

  return List.generate(maps.length, (index) {
    return DepositItemModel(
      itemID: maps[index]["itemID"],
      name: maps[index]["name"],
      location: maps[index]["location"],
      isPresent: maps[index]["isPresent"]
    );
  });
}

Future<int> updateItemPresence(DepositItemModel item) async
{
  final db = await getDatabase();

  int count = await db.update(
    "items",
    item.toMap(),
    where: "itemID = ?",
    whereArgs: [item.itemID]
  );

  return count;
}

Future<void> updateMultipleItemPresence(List<DepositItemModel> items) async
{
  final db = await getDatabase();

  for (DepositItemModel item in items) {
    await db.update(
      "items",
      item.toMap(),
      where: "itemID = ?",
      whereArgs: [item.itemID]
    );
  }
  
}

Future<void> deleteItems(List<DepositItemModel> itemsToDelete) async
{
  final db = await getDatabase();
  for (DepositItemModel item in itemsToDelete) {
    await db.delete("items", where: "itemID = ?", whereArgs: [item.itemID]);
  }
}


