import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// ========== Database Helper ==========
class DatabaseHelper {
  static const _settingsTable = 'Settings';
  static Database? _database;

  static Future<Database> get _db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'settings.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_settingsTable (
            key TEXT PRIMARY KEY,
            value INTEGER
          )
        ''');
        // Initialize default settings
        await db.insert(_settingsTable, {'key': 'notifications', 'value': 1});
        await db.insert(_settingsTable, {'key': 'darkMode', 'value': 0});
      },
    );
  }

  static Future<Map<String, bool>> getSettings() async {
    final db = await _db;
    final settings = await db.query(_settingsTable);
    return {
      for (var setting in settings)
        setting['key'] as String: (setting['value'] as int) == 1
    };
  }

  static Future<void> saveSettings(Map<String, bool> settings) async {
    final db = await _db;
    final batch = db.batch();
    settings.forEach((key, value) {
      batch.insert(
        _settingsTable,
        {'key': key, 'value': value ? 1 : 0},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    await batch.commit();
  }
}

// ========== Settings Screen ==========
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoading = true;

  static const List<Map<String, dynamic>> _settingsOptions = [
    {'title': 'Enable Notifications', 'icon': Icons.notifications},
    {'title': 'Enable Dark Mode', 'icon': Icons.dark_mode},
    {'title': 'Account Settings', 'icon': Icons.person},
    {'title': 'Privacy Policy', 'icon': Icons.privacy_tip},
    {'title': 'About', 'icon': Icons.info},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await DatabaseHelper.getSettings();
      setState(() {
        _notificationsEnabled = settings['notifications'] ?? true;
        _darkModeEnabled = settings['darkMode'] ?? false;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      await DatabaseHelper.saveSettings({
        'notifications': _notificationsEnabled,
        'darkMode': _darkModeEnabled,
      });
    } catch (e) {
      debugPrint('Error saving settings: $e');
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Failed to save settings')),
      );
    }
  }

  void _handleDarkModeChange(bool value) async {
    setState(() => _darkModeEnabled = value);
    await _saveSettings();
    
    // Update app theme immediately
    final brightness = value ? Brightness.dark : Brightness.light;
    final theme = Theme.of(context as BuildContext).copyWith(brightness: brightness);
    Navigator.of(context as BuildContext).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MaterialApp(
          theme: theme,
          home: const SettingsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _settingsOptions.length,
              itemBuilder: (context, index) {
                final option = _settingsOptions[index];
                return ListTile(
                  title: Text(option['title']),
                  leading: Icon(option['icon']),
                  trailing: index < 2
                      ? Switch(
                          value: index == 0 
                              ? _notificationsEnabled 
                              : _darkModeEnabled,
                          onChanged: index == 0
                              ? (bool value) async {
                                  setState(() => _notificationsEnabled = value);
                                  await _saveSettings();
                                }
                              : _handleDarkModeChange,
                        )
                      : null,
                  onTap: () {
                    if (index >= 2) {
                      debugPrint('Navigate to ${option['title']}');
                      // Implement navigation here
                    }
                  },
                );
              },
            ),
    );
  }
}