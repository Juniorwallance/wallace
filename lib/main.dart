// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:lipalocal/database/database_helper.dart' as db;
import 'package:lipalocal/database/task.dart' as t;
import 'package:lipalocal/screens/home_page.dart';
import 'package:lipalocal/screens/profile_screen.dart';
import 'package:lipalocal/screens/listings_screen.dart';
import 'package:lipalocal/screens/souvenirs_screen.dart';
import 'package:lipalocal/screens/orders_screen.dart';
import 'package:lipalocal/screens/messages_screen.dart';
import 'package:lipalocal/screens/settings_screen.dart';
import 'package:lipalocal/screens/signin_screen.dart';
import 'package:lipalocal/screens/artisan_list_page.dart';
import 'package:lipalocal/screens/location_tracker_page.dart';
import 'package:lipalocal/screens/signup_screen.dart';
import 'package:lipalocal/screens/aboutus_screen.dart';
import 'package:lipalocal/screens/registration_screen.dart';
import 'package:lipalocal/screens/tasks_screen.dart'; // Import your new screen

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
        '/location': (context) => const LocationTrackerPage(),
        '/task': (context) => const TaskScreen(),
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final dbHelper = db.DatabaseHelper();
  late Future<List<t.Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = dbHelper.fetchTasks() as Future<List<t.Task>>;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
