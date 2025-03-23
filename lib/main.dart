import 'package:aq/data/water_data.dart';
import 'package:aq/firebase_options.dart';
import 'package:aq/pages/homee_page.dart';
import 'package:aq/services/authentication/auth_gate.dart';
import 'package:aq/services/authentication/database_provider.dart';
import 'package:aq/services/storage/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [ 
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => StorageService()),
        ChangeNotifierProvider(create: (context) => WaterData()),
      ],
      child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
        '/home': (context) =>  const HomeePage(),
        },
        debugShowCheckedModeBanner: false,
        home: const AuthGate()
      );
  }
}