import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fyp_sports_v3/Cubit/internet_cubit/internet_cubit.dart';
import 'package:fyp_sports_v3/Helper/mongodb.dart';
import 'package:fyp_sports_v3/Screens/homescreen.dart';
import 'package:fyp_sports_v3/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

late SharedPreferences prefs;
bool? isFirstTime;
late BuildContext appContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await MongoDatabase.connectdb();
  prefs = await SharedPreferences.getInstance();
  // isFirstTime = prefs.getBool('isFirstTime') ?? true;
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetCubit(),
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, state) {
          if (state == InternetStates.gained) {
            appContext = context;
            return MaterialApp(
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                debugShowCheckedModeBanner: false,
                themeMode: ThemeMode.light,
                theme: ThemeData(
                    primaryColor: schemecolor,
                    appBarTheme: AppBarTheme(
                        iconTheme: const IconThemeData(color: Colors.white),
                        backgroundColor: schemecolor,
                        foregroundColor: Colors.white,
                        centerTitle: true,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: schemecolor,
                        )),
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: schemecolor,
                          foregroundColor: Colors.white),
                    ),
                    textTheme: GoogleFonts.outfitTextTheme(
                      Theme.of(context).textTheme,
                    ),
                    floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: schemecolor,
                    ),
                    scaffoldBackgroundColor: bgcolor,
                    fontFamily: GoogleFonts.outfit().fontFamily),
                darkTheme: ThemeData(
                  brightness: Brightness.light,
                  scaffoldBackgroundColor: Colors.black,
                ),
                home: const LoginorRegisterScreen());
          } else {
            return Container(
              height: double.infinity,
              color: Colors.white,
              child: Center(
                  child: Image.asset("assets/images/nointernet.jpg").p16()),
            );
          }
        },
      ),
    );
  }
}
