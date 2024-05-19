import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:fyp_sports_v3/main.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> _trialsFuture;
  late Future<List<Map<String, dynamic>>> _trialRequestsFuture;

  @override
  void initState() {
    super.initState();
    _trialsFuture = _fetchTrials();
    _trialRequestsFuture = _fetchTrialRequests(prefs.getString('email')!);
  }

  Future<List<Map<String, dynamic>>> _fetchTrials() async {
    List<Map<String, dynamic>> trials = await MongoDatabase.fetchtrials();
    return trials;
  }

  Future<List<Map<String, dynamic>>> _fetchTrialRequests(
      String userEmail) async {
    return MongoDatabase.fetchTrialRequests(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: Future.wait([_trialsFuture, _trialRequestsFuture]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: schemecolor,
                strokeWidth: 2,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> trials = snapshot.data![0] ?? [];
            List<Map<String, dynamic>> trialRequests = snapshot.data![1] ?? [];
            return ListView.builder(
              itemCount: trials.length,
              itemBuilder: (context, index) {
                var trial = trials[index];
                var trialRequest = trialRequests.firstWhere(
                  (request) => request['trialName'] == trial['trialName'],
                  orElse: () => {'status': -1}, // Default status if not found
                );
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          title: Text('Trial : ' + trial['trialName']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${trial['location']}'),
                              Text('Date: ${trial['trialDate']}'),
                              Text('Time: ${trial['trialTime']}'),
                              Text('Organizer: ${trial['organizer']}'),
                              Text('Category: ${trial['trialCategory']}'),
                            ],
                          ),
                        ),
                        trialRequest['status'] == 0 ||
                                trialRequest['status'] == 1 ||
                                trialRequest['status'] == 2
                            ? trialRequest['status'] == 0
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: null, // Disabled button
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              return Colors.orange; // Pending
                                            }
                                            return schemecolor; // Default color
                                          },
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white), // Approved
                                      ),
                                      child: Text('Status: Pending'),
                                    ),
                                  )
                                : trialRequest['status'] == 1
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: null, // Disabled button
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.green), // Approved
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.white), // Approved
                                          ),
                                          child: Text('Status: Approved'),
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: null, // Disabled button
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.red), // Rejected
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Colors.white), // Approved
                                          ),
                                          child: Text('Status: Rejected'),
                                        ),
                                      )
                            : prefs.getString('category') ==
                                    trial['trialCategory']
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Call method to add trial request
                                          MongoDatabase.addTrialRequest(
                                            trial['trialName'],
                                            trial['organizer'],
                                            prefs.getString('name')!,
                                            prefs.getString('email')!,
                                            trial['trialCategory'],
                                          ).then((value) =>
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardScreen()),
                                              ));
                                        },
                                        child: Text('Apply'),
                                      ),
                                    ),
                                  )
                                : Container(),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
