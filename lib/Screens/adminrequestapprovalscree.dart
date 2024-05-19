import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminTrialApprovalScreen extends StatefulWidget {
  const AdminTrialApprovalScreen({Key? key}) : super(key: key);

  @override
  State<AdminTrialApprovalScreen> createState() =>
      _AdminTrialApprovalScreenState();
}

class _AdminTrialApprovalScreenState extends State<AdminTrialApprovalScreen> {
  List<Map<String, dynamic>> trialRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrialRequests();
  }

  Future<void> fetchTrialRequests() async {
    try {
      List<Map<String, dynamic>> requests =
          await MongoDatabase.fetchTrialRequestsforadmin();
      setState(() {
        trialRequests = requests;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching trial requests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trial Approval'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: schemecolor,
                strokeWidth: 2,
              ),
            )
          : trialRequests.isEmpty
              ? Center(
                  child: Text('No trial requests found.'),
                )
              : ListView.builder(
                  itemCount: trialRequests.length,
                  itemBuilder: (context, index) {
                    var request = trialRequests[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(request['trialName']),
                            subtitle:
                                Text('Organizer: ${request['organizer']}'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User Name: ${request['userName']}'),
                                Text('User Email: ${request['userEmail']}'),
                                Text('Category: ${request['category']}'),
                                Text('Status: ${request['status']}'),
                              ],
                            ),
                          ),
                          request['status'] == 0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool success = await MongoDatabase
                                            .approveTrialRequest(
                                                request['trialName']);
                                        if (success) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminTrialApprovalScreen()));
                                        } else {
                                          VxToast.show(context,
                                              msg:
                                                  'Something Went Wrong Try Again.',
                                              bgColor: const Color.fromARGB(
                                                  255, 255, 17, 0),
                                              textColor: Colors.white);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Text('Approve'),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool success = await MongoDatabase
                                            .rejectTrialRequest(
                                                request['trialName']);
                                        if (success) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminTrialApprovalScreen()));
                                        } else {
                                          VxToast.show(context,
                                              msg:
                                                  'Something Went Wrong Try Again.',
                                              bgColor: const Color.fromARGB(
                                                  255, 255, 17, 0),
                                              textColor: Colors.white);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Text('Reject'),
                                    ),
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    request['status'] == 1
                                        ? 'Approved'
                                        : 'Rejected',
                                    style: TextStyle(
                                      color: request['status'] == 1
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ).pOnly(right: 8, bottom: 8),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
