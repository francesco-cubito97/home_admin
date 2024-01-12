import 'package:flutter/material.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
        
          child: Center(child: Text('Elevated Card')),
        ),
      ),
    );
  }
}