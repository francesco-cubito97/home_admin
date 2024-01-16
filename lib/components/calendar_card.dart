import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return  Center(
      child: Card(
        color: theme.colorScheme.tertiary,
        margin: EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
        
          child: Center(child: Text('Elevated Card')),
        ),
      ),
    );
  }
}