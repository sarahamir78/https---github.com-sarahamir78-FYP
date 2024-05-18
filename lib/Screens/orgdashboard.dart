import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Screens/addtrials.dart';
import 'package:fyp_sports_v3/main.dart';

class OrgDashboard extends StatefulWidget {
  const OrgDashboard({Key? key}) : super(key: key);

  @override
  State<OrgDashboard> createState() => _OrgDashboardState();
}

class _OrgDashboardState extends State<OrgDashboard> {
  late Future<List<Map<String, dynamic>>> _trialsFuture;

  @override
  void initState() {
    super.initState();
    _trialsFuture = _fetchTrials();
  }

  Future<List<Map<String, dynamic>>> _fetchTrials() async {
    String email = prefs.getString('orgemail') ??
        ''; // Get organization email from shared preferences
    List<Map<String, dynamic>> trials =
        await MongoDatabase.fetchTrialsByOrganizationEmail(email);
    return trials;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Franchise Dashboard'),
      ),
      body: FutureBuilder(
        future: _trialsFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> trials = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: trials.length,
                    itemBuilder: (context, index) {
                      var trial = trials[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text(trial['trialName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Location: ${trial['location']}'),
                                Text('Date: ${trial['trialDate']}'),
                                Text('Time: ${trial['trialTime']}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                prefs.getInt('orgapproved') == 1
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTrialsScreen()));
                          },
                          child: Text('Add Trial'),
                        ),
                      )
                    : Container()
              ],
            );
          }
        },
      ),
    );
  }
}
