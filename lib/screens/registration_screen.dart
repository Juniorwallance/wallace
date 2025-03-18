import 'package:flutter/material.dart';

void main() => runApp(LipalocalApp());

class LipalocalApp extends StatelessWidget {
  const LipalocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lipalocal Registration',
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _userType = 'Artisan'; // Default user type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lipalocal Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _userType,
                onChanged: (String? newValue) {
                  setState(() {
                    _userType = newValue!;
                  });
                },
                items: <String>['Artisan', 'Tourist']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Register as'),
              ),
              if (_userType == 'Artisan') ..._buildArtisanForm(),
              if (_userType == 'Tourist') ..._buildTouristForm(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process registration
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildArtisanForm() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Full Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email Address'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Phone Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Skill'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your skill';
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _buildTouristForm() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Full Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your full name';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email Address'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Phone Number'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          return null;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Country'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your country';
          }
          return null;
        },
      ),
    ];
  }
}
