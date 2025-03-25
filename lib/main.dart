// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Import sqflite
// ignore: depend_on_referenced_packages
import 'package:path/path.dart'; // Import path
import 'package:path_provider/path_provider.dart'; // Import path_provider

import 'package:lipalocal/screens/home_page.dart';
import 'package:lipalocal/screens/profile_screen.dart';
import 'package:lipalocal/screens/listings_screen.dart';
import 'package:lipalocal/screens/souvenirs_screen.dart';
import 'package:lipalocal/screens/orders_screen.dart';
import 'package:lipalocal/screens/messages_screen.dart';
import 'package:lipalocal/screens/settings_screen.dart';
import 'package:lipalocal/screens/signin_screen.dart';
import 'package:lipalocal/screens/artisan_list_page.dart';
import 'package:lipalocal/screens/signup_screen.dart';
import 'package:lipalocal/screens/aboutus_screen.dart';
import 'package:lipalocal/screens/registration_screen.dart';

void main() {
  runApp(const LipaLocalApp());
}

class LipaLocalApp extends StatelessWidget {
  const LipaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LipaLocal',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfileScreen(),
        '/listings': (context) => const ListingsScreen(),
        '/souvenirs': (context) => const SouvenirsScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignupPage(),
        '/aboutus': (context) => const AboutUsPage(),
        '/registration': (context) => const RegistrationPage(),
        '/artisans': (context) => const ArtisanListPage(),
      },
    );
  }
}
