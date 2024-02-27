import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// This component permits to see each single day.
// Will be visible the day, the week (clickable),
// and the month (clickable). Moreover, will be visible
// also the recipes choosen and, with dropdown lists, will
// be possible choose other recipes.

/// Day by Day visualization
class DayCard extends StatelessWidget {
  const DayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final currentDay = DateFormat('d').format(today);
    final currentWeekDay = DateFormat('E').format(today);
    final currentMonth = DateFormat('MMM').format(today);
    final currentYear = DateFormat('y').format(today);

    return  Center(
      child: Card(
        color: theme.colorScheme.tertiary,
        margin: EdgeInsets.all(15),
        child: SizedBox(
          width: double.infinity,
        
          child: Column(
            children: [
              Text(currentDay),
              Text(currentWeekDay),
              Text(currentMonth),
              Text(currentYear),
            ]
          ),
        ),
      ),
    );
  }
}

/// Week by Week visualization
class WeekCard extends StatelessWidget {
  const WeekCard({super.key});

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

/// Month visualization
class MonthCard extends StatelessWidget {
  const MonthCard({super.key});

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

