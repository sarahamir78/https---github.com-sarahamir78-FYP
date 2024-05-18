import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Screens/addtrials.dart';

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({super.key});

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Franchise Dashboard'),
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTrialsScreen()));
              },
              child: Text('Add Trial'))),
    );
  }
}
