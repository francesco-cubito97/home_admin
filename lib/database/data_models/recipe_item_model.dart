import 'package:home_adm/database/data_models/deposit_item_model.dart';

class RecipeItemModel 
{
  // An element inside the menu has a name,
  // a list of ingredients, and a description
  final int itemID;
  final String name;

  final String description;

  // These should be derived from the join of recipe and deposit items IDs
  List<DepositItemModel>? ingredients;

  RecipeItemModel({ this.itemID=0, required this.name, this.description = "" });

  // Convert a recipe into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description
    };
  }

  // Implement toString to make it easier to see information about
  // each recipe when using the print statement.
  @override
  String toString() {
    return 'Recipe {itemID: $itemID, name: $name, location: $description}';
  }
}