import 'package:flutter/material.dart';

// Firebase activation
//import 'package:firebase_core/firebase_core.dart';
//import 'package:home_adm/firebase_options.dart';

import 'package:home_adm/pages/home.dart';



// For a future use of Firebase
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(const MyApp());
// }


void main() async
{
  
  runApp(const MyApp());
}

// This is the main class, here will start all pages

class MyApp extends StatelessWidget {

  const MyApp({super.key});  

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, secondary: Colors.amber, tertiary: const Color.fromARGB(129, 244, 67, 54)),
      ),
      home: const HomePage(title: 'HomeAdm'),
      
    );
  }
}


