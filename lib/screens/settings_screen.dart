import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  // Constants for titles and icons
  static const List<Map<String, dynamic>> _settingsOptions = [
    {'title': 'Enable Notifications', 'icon': Icons.notifications},
    {'title': 'Enable Dark Mode', 'icon': Icons.dark_mode},
    {'title': 'Account Settings', 'icon': Icons.person},
    {'title': 'Privacy Policy', 'icon': Icons.privacy_tip},
    {'title': 'About', 'icon': Icons.info},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: _settingsOptions.length,
        itemBuilder: (context, index) {
          final option = _settingsOptions[index];
          return _buildListTile(option, index);
        },
      ),
    );
  }

  Widget _buildListTile(Map<String, dynamic> option, int index) {
    return ListTile(
      title: Text(option['title']),
      leading: Icon(option['icon']),
      trailing: index < 2 // Show switch for the first two options
          ? Switch(
              value: index == 0 ? _notificationsEnabled : _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  if (index == 0) {
                    _notificationsEnabled = value;
                  } else {
                    _darkModeEnabled = value;
                  }
                });
              },
            )
          : null,
      onTap: () {
        if (index >= 2) {
          // Navigate to respective pages
          // ignore: avoid_print
          print('Navigate to ${option['title']}');
          // Example navigation code:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => YourNextPage()));
        }
      },
    );
  }
}
