import 'package:flutter/material.dart';
import 'package:home_adm/pages/deposit.dart';
import 'package:home_adm/pages/shopping.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title="Home Page"});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BigCardTitle(title: widget.title),
            const SizedBox(height: 100,),
            // Four buttons, each with a specific page associated,
            // organized in two rows
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Deposit button
                HomeButton(icon: const Icon(Icons.food_bank_outlined), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DepositPage()),
                  );
                }),
                // Shopping cart button
                HomeButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShoppingPage()),
                  );
                })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                HomeButton(icon: const Icon(Icons.dinner_dining_outlined), onPressed: () {}),
                HomeButton(icon: const Icon(Icons.attach_money_outlined), onPressed: () {})
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Icon icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    double elevation = 20.0;
    final theme = Theme.of(context);

    final style = ButtonStyle(
      elevation: MaterialStatePropertyAll(elevation),
      iconSize: const MaterialStatePropertyAll(110.0),
      backgroundColor: MaterialStatePropertyAll(theme.colorScheme.secondary), 
      iconColor: MaterialStatePropertyAll(theme.colorScheme.onPrimary),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        )
    ));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(onPressed: onPressed, style: style, child: icon),
    );
  }
}

class BigCardTitle extends StatelessWidget {
  const BigCardTitle({
    super.key,
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayLarge!.copyWith(color: theme.colorScheme.onPrimary);

    return Card(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: theme.colorScheme.onPrimary,
          width: 5,
          strokeAlign: -3,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}
