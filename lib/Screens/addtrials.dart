import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Screens/orgdashboard.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:fyp_sports_v3/main.dart';
import 'package:velocity_x/velocity_x.dart';

class AddTrialsScreen extends StatefulWidget {
  const AddTrialsScreen({super.key});

  @override
  State<AddTrialsScreen> createState() => _AddTrialsScreenState();
}

class _AddTrialsScreenState extends State<AddTrialsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trialNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _trialTimeController = TextEditingController();
  final TextEditingController _trialDateController =
      TextEditingController(); // Added TextEditingController for date
  String? _selectedCategory;
  bool _loading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      bool result = await MongoDatabase.addTrial(
          _trialNameController.text,
          _selectedCategory!,
          DateTime.parse(
              _trialDateController.text), // Parsing date from controller
          _trialTimeController.text,
          _locationController.text,
          _descriptionController.text,
          prefs.getString('orgname')!);

      if (result) {
        VxToast.show(context,
            msg: 'Trial Added Successfully',
            bgColor: Colors.green,
            textColor: Colors.white);
        _formKey.currentState!.reset();
        setState(() {
          _trialDateController.clear(); // Clear date controller
          _selectedCategory = null;
          _locationController.clear();
          _descriptionController.clear();
          _trialNameController.clear();
          _trialTimeController.clear();
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
        });
        VxToast.show(context,
            msg: 'Failed to Add. Please try again.',
            bgColor: const Color.fromARGB(255, 255, 17, 0),
            textColor: Colors.white);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _trialDateController.text = pickedDate
            .toLocal()
            .toString()
            .split(' ')[0]; // Setting date in controller
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _trialTimeController.text = pickedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrgDashboard()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Trials'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _trialNameController,
                    decoration: InputDecoration(labelText: 'Trial Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter trial name';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Trial Category'),
                    value: _selectedCategory,
                    items: ['Under 13', 'Under 15', 'Under 19', 'Above 19']
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
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
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _trialTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Trial Time (HH:MM)',
                    ),
                    onTap: () => _selectTime(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter trial time';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _trialDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Trial Date (YYYY-MM-DD)',
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter trial date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: schemecolor,
                            strokeWidth: 2,
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Submit'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
