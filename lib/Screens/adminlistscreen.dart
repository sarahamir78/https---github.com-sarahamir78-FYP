import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Screens/adminrequestapprovalscree.dart';
import 'package:fyp_sports_v3/Screens/adminscreen.dart';

class AdminListScreen extends StatefulWidget {
  const AdminListScreen({super.key});

  @override
  State<AdminListScreen> createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Screen',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 3,
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminScreen()));
              },
              tileColor: Colors.white,
              selectedColor: Colors.white,
              title: Text('Organization Requests'),
              leading: Icon(Icons.admin_panel_settings),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 3,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminTrialApprovalScreen()));
              },
              tileColor: Colors.white,
              selectedColor: Colors.white,
              title: Text('Trials Request'),
              leading: Icon(Icons.admin_panel_settings),
            ),
          )
        ],
      ),
    );
  }
}
