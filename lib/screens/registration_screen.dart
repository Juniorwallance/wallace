import 'package:flutter/material.dart';
import 'package:lipalocal/database/database_helper.dart'; // Importing the database helper

void main() => runApp(const LipalocalApp());

class LipalocalApp extends StatelessWidget {
  const LipalocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lipalocal Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationPage(),
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
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _skillOrCountryController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _skillOrCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lipalocal Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Dropdown to select user type (Artisan/Tourist)
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
                decoration: const InputDecoration(labelText: 'Register as'),
              ),
              // Conditional rendering of forms based on user type
              if (_userType == 'Artisan') ..._buildArtisanForm(),
              if (_userType == 'Tourist') ..._buildTouristForm(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Process registration logic here
                    if (_userType == 'Artisan') {
                      await _registerArtisan();
                    } else {
                      await _registerTourist();
                    }
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build form fields specific to Artisan registration
  List<Widget> _buildArtisanForm() {
    return [
      _buildTextField(label: 'Full Name', controller: _fullNameController, validator: _validateNotEmpty),
      _buildTextField(label: 'Email Address', controller: _emailController, validator: _validateEmail),
      _buildTextField(label: 'Phone Number', controller: _phoneNumberController, validator: _validateNotEmpty),
      _buildTextField(label: 'Skill', controller: _skillOrCountryController, validator: _validateNotEmpty),
    ];
  }

  // Build form fields specific to Tourist registration
  List<Widget> _buildTouristForm() {
    return [
      _buildTextField(label: 'Full Name', controller: _fullNameController, validator: _validateNotEmpty),
      _buildTextField(label: 'Email Address', controller: _emailController, validator: _validateEmail),
      _buildTextField(label: 'Phone Number', controller: _phoneNumberController, validator: _validateNotEmpty),
      _buildTextField(label: 'Country', controller: _skillOrCountryController, validator: _validateNotEmpty),
    ];
  }

  // Helper method to create text fields with validation
  TextFormField _buildTextField({required String label, required TextEditingController controller, required String? Function(String?) validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }

  // Validation function to check if a field is not empty
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $value';
    }
    return null;
  }

  // Validation function to check if the email format is valid
  String? _validateEmail(String? value) {
    // Simple email validation regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _registerArtisan() async {
    await DatabaseHelper.insertArtisan({
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
      'skill': _skillOrCountryController.text,
    });
    _showRegistrationSuccess();
  }

  Future<void> _registerTourist() async {
    await DatabaseHelper.insertTourist({
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
      'country': _skillOrCountryController.text,
    });
    _showRegistrationSuccess();
  }

  void _showRegistrationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
    // Clear the form fields after successful registration
    _fullNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _skillOrCountryController.clear();
  }
}