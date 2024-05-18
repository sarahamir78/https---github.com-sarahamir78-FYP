import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Screens/dashboard.dart';
import 'package:fyp_sports_v3/Screens/orgdashboard.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:fyp_sports_v3/main.dart';
import 'package:velocity_x/velocity_x.dart';

class OrgLogin extends StatefulWidget {
  const OrgLogin({Key? key}) : super(key: key);

  @override
  State<OrgLogin> createState() => _OrgLoginState();
}

class _OrgLoginState extends State<OrgLogin> {
  @override
  void initState() {
    super.initState();
  }

  bool pressed = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _username = GlobalKey<FormState>();
  final GlobalKey<FormState> _password = GlobalKey<FormState>();

  void _login() async {
    setState(() {
      pressed = false;
    });
    String email = username.text;
    String pass = password.text;

    bool loginSuccess = await MongoDatabase.loginorg(email, pass);

    if (loginSuccess) {
      setState(() {
        pressed = true;
      });
      prefs.setString('orgemail', email);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OrgDashboard()));
    } else {
      setState(() {
        pressed = true;
      });
      VxToast.show(context,
          msg: 'Invalid email or password',
          bgColor: const Color.fromARGB(255, 255, 17, 0),
          textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 100;
    final width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Login'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset("assets/images/bg.jpg", fit: BoxFit.contain),
              ),
              Text(
                "Login Page",
                maxLines: 1,
                style: TextStyle(
                    fontSize: height * 3, fontWeight: FontWeight.bold),
              ).pOnly(top: 10),
              const Text(
                "Sign In To Continue",
                maxLines: 1,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).pOnly(top: 10),
              const SizedBox(
                height: 20,
              ),
              Theme(
                data:
                    Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: Form(
                  key: _username,
                  child: TextFormField(
                    controller: username,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please Enter Email';
                      }
                    },
                    maxLength: 30,
                    autocorrect: false,
                    onTap: () {},
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.person_fill,
                        color: loginicon,
                      ),
                      filled: true,
                      fillColor: textboxcolor,
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ).pOnly(left: 15, right: 15),
              Theme(
                data:
                    Theme.of(context).copyWith(splashColor: Colors.transparent),
                child: Form(
                  key: _password,
                  child: TextFormField(
                    obscureText: true,
                    controller: password,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please Enter Password';
                      }
                    },
                    maxLength: 30,
                    autocorrect: false,
                    onTap: () {},
                    style: const TextStyle(fontSize: 14.0, color: Colors.black),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key_sharp,
                        color: loginicon,
                      ),
                      filled: true,
                      fillColor: textboxcolor,
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ).pOnly(left: width * 3.9, right: width * 3.9),
              pressed
                  ? ElevatedButton(
                      onPressed: () async {
                        if (!_username.currentState!.validate()) {
                          return;
                        }
                        if (!_password.currentState!.validate()) {
                          return;
                        }
                        _login();
                      },
                      child: Text(
                        "Sign In",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: height * 1.7,
                            fontWeight: FontWeight.bold),
                      ).pOnly(left: 20, right: 20),
                      style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    )
                  : CircularProgressIndicator(
                      color: schemecolor,
                      strokeWidth: 2,
                    ),
            ],
          )),
        ),
      ),
      bottomNavigationBar: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered By CodeVista",
            maxLines: 1,
            style:
                TextStyle(fontSize: height * 1.8, fontWeight: FontWeight.bold),
          ).p4()
        ],
      ),
    );
  }
}
