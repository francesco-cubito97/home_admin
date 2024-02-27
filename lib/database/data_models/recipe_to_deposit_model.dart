class RecipeToDepositModel 
{
  // Each recipe is associated with N deposit items. So is necessary
  // to create a table with the two objects inside it.
  final int recipeID;
  final int depositID;

  RecipeToDepositModel({ required this.recipeID, required this.depositID });

  // Convert a deposit item into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'recipeID': recipeID,
      'depositID': depositID,
    };
  }

  // Implement toString to make it easier to see information about
  // each deposit item when using the print statement.
  @override
  String toString() {
    return 'RecipeToDeposit {recipeID: $recipeID, depositID: $depositID}';
  }
}