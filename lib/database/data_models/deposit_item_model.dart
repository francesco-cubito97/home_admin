class DepositItemModel 
{
  // An element inside the deposit and inside the shopping cart has a name,
  // a location, and if it is present
  final int itemID;
  final String name;
  final int location;
  int isPresent;
  bool selected = false;

  DepositItemModel({ this.itemID=0, required this.name, required this.location, this.isPresent = 1 });

  // Convert a deposit item into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'isPresent': isPresent
    };
  }

  // Implement toString to make it easier to see information about
  // each deposit item when using the print statement.
  @override
  String toString() {
    return 'Item {itemID: $itemID, name: $name, location: $location, isPresent: $isPresent}';
  }
}