import 'package:flutter/material.dart';

class NestedListTitle extends StatelessWidget {
  const NestedListTitle({super.key, required this.itemListTitle});

  final String itemListTitle;
  
  @override
  Widget build(BuildContext context) {
    return Container(
              color: Colors.tealAccent,
              alignment: Alignment.center,
              height: 50,
              child: Text(itemListTitle),
          );
    
  }
}

class NestedList extends StatelessWidget {
  NestedList({super.key, 
                    required this.itemListTitle,
                    required this.itemsWidget 
                  });

  final String itemListTitle;
  final List<Widget> itemsWidget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
         Container(
              color: theme.colorScheme.tertiary,
              alignment: Alignment.center,
              height: 50,
              child: Text(itemListTitle),
            ),
        ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: itemsWidget
        )
    
      ]
    );
    
  }
}