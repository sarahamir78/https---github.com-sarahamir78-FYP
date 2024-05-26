import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Helper/pdf.dart';
import 'package:fyp_sports_v3/Models/pdfmodel.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:velocity_x/velocity_x.dart';

class OrganizationRegistration extends StatefulWidget {
  const OrganizationRegistration({Key? key}) : super(key: key);

  @override
  _OrganizationRegistrationState createState() =>
      _OrganizationRegistrationState();
}

class _OrganizationRegistrationState extends State<OrganizationRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  String? _selectedCategory;
  PdfFile? pdfFile;
  bool _loading = false;

  void _registerorganization() async {
    setState(() {
      _loading = true;
    });
    // Extract user data from form fields
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String location = _location.text;
    String contact = _contactController.text;
    String address = _addressController.text;
    String organization = _organizationController.text;
    String? category = _selectedCategory;

    // Call MongoDB class to insert user data
    bool success = await MongoDatabase.registerOrganization(
      name,
      email,
      password,
      location,
      contact,
      address,
      organization,
      category,
      pdfFile, // Pass the pdfFile parameter
    );

    if (success) {
      // Registration successful
      VxToast.show(context,
          msg: 'Registration Successful',
          bgColor: Colors.green,
          textColor: Colors.white);
      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _location.clear();
      _contactController.clear();
      _addressController.clear();
      _organizationController.clear();
      setState(() {
        _selectedCategory = null;
        pdfFile = null; // Clear the pdfFile after registration
        _loading = false;
      });
    } else {
      setState(() {
        _loading = true;
      });
      VxToast.show(context,
          msg: 'Failed to register. Please try again.',
          bgColor: const Color.fromARGB(255, 255, 17, 0),
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Registration'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Org Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Org Email'),
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
                  decoration: InputDecoration(labelText: 'Org Password'),
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
                  controller: _location,
                  decoration: InputDecoration(labelText: 'Headoffice Location'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Headoffice Location';
                    }
                    // Add more specific CNIC validation if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Org Contact'),
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
                  decoration: InputDecoration(labelText: 'Org Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _organizationController,
                  decoration: InputDecoration(
                      labelText: 'Organization Affiliated With'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your organization';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Select Organization'),
                  items: ['National', 'International', 'Franchise']
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
                      return 'Please select an Organization';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Upload documents ",
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        pdfFile?.file.path.toString() ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        pdfFile = await THelperFunction.pickFilePdf(context);
                        setState(() {});
                      },
                      child: Material(
                        elevation: 4.0,
                        child: Container(
                          color: schemecolor,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "Choose File",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                            _registerorganization();
                          }
                        },
                        child: Text('Register'),
                      ),
              ]))),
    );
  }
}
