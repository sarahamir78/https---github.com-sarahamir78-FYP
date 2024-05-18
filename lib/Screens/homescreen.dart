import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Screens/adminscreen.dart';
import 'package:fyp_sports_v3/Screens/loginscreen.dart';
import 'package:fyp_sports_v3/Screens/organizationregister.dart';
import 'package:fyp_sports_v3/Screens/orglogin.dart';
import 'package:fyp_sports_v3/Screens/playerregistration.dart';
import 'package:fyp_sports_v3/config.dart';

class LoginorRegisterScreen extends StatefulWidget {
  const LoginorRegisterScreen({Key? key}) : super(key: key);

  @override
  State<LoginorRegisterScreen> createState() => _LoginorRegisterScreenState();
}

class _LoginorRegisterScreenState extends State<LoginorRegisterScreen> {
  bool _isExpanded = false;
  bool _isExpanded1 = false;

  @override
  void initState() {
    //deletedata();
    super.initState();
  }

  deletedata() async {
    await MongoDatabase.deleteAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login & Register'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomCenter),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              // Use ListView instead of SingleChildScrollView
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: _isExpanded ? 220 : 70,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      dense: false,
                      backgroundColor: Colors.white,
                      leading: Icon(Icons.login, color: schemecolor),
                      collapsedIconColor: schemecolor,
                      title: Text(
                        'Login',
                        style: TextStyle(color: schemecolor),
                      ),
                      children: [
                        ListTile(
                          leading: Icon(Icons.sports_cricket),
                          title: Text(
                            'Cricket Player',
                            style: TextStyle(),
                          ),
                          subtitle: Text(
                            'Login as Cricket Player',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.sports_cricket),
                          title: Text(
                            'Cricket Organization',
                            style: TextStyle(),
                          ),
                          subtitle: Text(
                            'Login as Cricket Organization',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrgLogin()));
                          },
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isExpanded = expanded;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  height: _isExpanded1 ? 220 : 70,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.white,
                      dense: false,
                      backgroundColor: Colors.white,
                      leading: Icon(Icons.person_add, color: schemecolor),
                      collapsedIconColor: schemecolor,
                      title: Text(
                        'Register',
                        style: TextStyle(color: schemecolor),
                      ),
                      children: [
                        ListTile(
                          leading: Icon(Icons.sports_cricket),
                          title: Text(
                            'Cricket Player',
                            style: TextStyle(),
                          ),
                          subtitle: Text(
                            'Register as Cricket Player',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PlayerRegistration()));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.sports_cricket),
                          title: Text(
                            'Cricket Organization',
                            style: TextStyle(),
                          ),
                          subtitle: Text(
                            'Register as Cricket Organization',
                            style: TextStyle(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrganizationRegistration()));
                          },
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isExpanded1 = expanded;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Card(
                  color: Colors.white,
                  elevation: 3,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminScreen()));
                    },
                    tileColor: Colors.white,
                    selectedColor: Colors.white,
                    title: Text('Admin Panel'),
                    leading: Icon(Icons.admin_panel_settings),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
