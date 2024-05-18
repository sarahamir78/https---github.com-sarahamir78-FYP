import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/config.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late Future<List<Map<String, dynamic>>> organizationsFuture;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    organizationsFuture = MongoDatabase.fetchOrganizations();
  }

  Future<void> _updateOrganizationStatus(String id, int status) async {
    setState(() {
      isLoading = true;
    });

    bool success =
        await MongoDatabase.updateOrganizationApprovalStatus(id, status);
    if (success) {
      // Re-fetch the data from the database
      organizationsFuture = MongoDatabase.fetchOrganizations();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: schemecolor,
              strokeWidth: 2,
            ))
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: organizationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No organizations found'));
                }

                List<Map<String, dynamic>> organizations = snapshot.data!;

                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    var org = organizations[index];
                    return Card(
                      elevation: 4.0,
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Org Name : ' + org['orgname'],
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text('Email: ${org['orgemail'] ?? 'N/A'}'),
                            Text('Password: ${org['orgpassword'] ?? 'N/A'}'),
                            Text('Location: ${org['location'] ?? 'N/A'}'),
                            Text('Contact: ${org['contact'] ?? 'N/A'}'),
                            Text('Address: ${org['address'] ?? 'N/A'}'),
                            Text(
                                'Organization: ${org['organization'] ?? 'N/A'}'),
                            Text('Category: ${org['category'] ?? 'N/A'}'),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (org['isapproved'] == 0) ...[
                                  ElevatedButton(
                                    onPressed: () => _updateOrganizationStatus(
                                        org['_id'].toHexString(), 1),
                                    child: Text('Approve'),
                                  ),
                                  SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () => _updateOrganizationStatus(
                                        org['_id'].toHexString(), 2),
                                    child: Text('Reject'),
                                  ),
                                ] else if (org['isapproved'] == 1) ...[
                                  Text(
                                    'Approved',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ] else if (org['isapproved'] == 2) ...[
                                  Text(
                                    'Rejected',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
