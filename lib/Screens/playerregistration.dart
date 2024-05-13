import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerRegistration extends StatefulWidget {
  const PlayerRegistration({Key? key}) : super(key: key);

  @override
  _PlayerRegistrationState createState() => _PlayerRegistrationState();
}

class _PlayerRegistrationState extends State<PlayerRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  String? _selectedCategory;
  String? _selectedGender;
  bool _loading = false;

  void _registerUser() async {
    setState(() {
      _loading = true;
    });
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String cnic = _cnicController.text;
    String contact = _contactController.text;
    String address = _addressController.text;
    String organization = _organizationController.text;
    String? category = _selectedCategory;
    String? gender = _selectedGender;

    // Call MongoDB class to insert user data
    bool success = await MongoDatabase.registerUser(
      name,
      email,
      password,
      cnic,
      contact,
      address,
      organization,
      category,
      gender,
    );

    if (success) {
      VxToast.show(context,
          msg: 'Registration Successful',
          bgColor: Colors.green,
          textColor: Colors.white);
      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _cnicController.clear();
      _contactController.clear();
      _addressController.clear();
      _organizationController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedGender = null;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      VxToast.show(context,
          msg: 'Failed to register. Please try again.',
          bgColor: const Color.fromARGB(255, 255, 17, 0),
          textColor: Colors.white);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cnicController,
                decoration: InputDecoration(labelText: 'CNIC'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CNIC';
                  }
                  // Add more specific CNIC validation if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  // Add more specific contact validation if needed
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _organizationController,
                decoration:
                    InputDecoration(labelText: 'Organization Affiliated With'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your organization';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: ['Under 13', 'Under 15', 'Under 19', 'Above 19']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Gender',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'male',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text('Male'),
                      Radio<String>(
                        value: 'female',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ],
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: schemecolor,
                        strokeWidth: 2,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _registerUser();
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
}
