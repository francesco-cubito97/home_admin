import 'package:home_adm/globals.dart' as constants;
import 'package:home_adm/database/data_models/deposit_item_model.dart';
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

    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
        'CREATE TABLE recipe_deposit(recipeID INTEGER, depositID INTEGER, PRIMARY KEY(recipeID, depositID))',
      );
      db.execute(
        'CREATE TABLE recipes(itemID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, description TEXT)',
      );
      return db.execute(
        'CREATE TABLE items(itemID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, location INTEGER, isPresent INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}


// Define a function that inserts items into the database
Future<void> insertNewItem(DepositItemModel item) async {
  // Get a reference to the database.
  final db = await getDatabase();

  // Insert the Item into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //
  // In this case, replace any previous data.
  await db.insert(
    'items',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
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

Future<void> updateItemPresence(DepositItemModel item) async
{
  final db = await getDatabase();

  await db.update(
    "items",
    item.toMap(),
    where: "itemID = ?",
    whereArgs: [item.itemID]
  );
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


