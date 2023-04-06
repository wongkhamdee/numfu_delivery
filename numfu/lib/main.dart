import 'package:flutter/material.dart';
import 'package:numfu/main_page.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/login.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext Context) => Login(),
  '/Launcher': (BuildContext Context) => Launcher(),
};

String? initlalRoute;
Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? email = preferences.getString('email');
  print('## email ===> $email');
  if (email?.isEmpty ?? true) {
    initlalRoute = MyCostant.routelogin;
    runApp(MyApp());
  } else {
    initlalRoute = MyCostant.routeluncher;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyCostant.appName,
      routes: map,
      initialRoute: initlalRoute,
      theme: ThemeData(
        fontFamily: 'MN',
        primarySwatch: Colors.orange,
        backgroundColor: Colors.white,
      ),
    );
  }
}
