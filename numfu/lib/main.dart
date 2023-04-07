import 'package:flutter/material.dart';
import 'package:numfu/main_page.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/OTP.dart';
import 'package:numfu/screen/index.dart';
import 'package:numfu/screen/login.dart';
import 'package:numfu/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  '/login': (BuildContext Context) => Login(),
  '/Launcher': (BuildContext Context) => Launcher(),
};

String? initlalRoute;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initlalRoute = MyCostant.routeluncher;
  runApp(const MyApp());
}
/*void main() async {
  await Hive.initFlutter();
  initlalRoute = MyCostant.routelogin;
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,

      title: MyCostant.appName,
      routes: map,
      //initialRoute: initlalRoute,
      theme: ThemeData(
        fontFamily: 'MN',
        //textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.orange,
        backgroundColor: Colors.white,
      ),
      home: MainPage(),
    );
  }
}


/*void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Numfu',
        theme: ThemeData(
          fontFamily: 'MN',
          //textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.orange,
          backgroundColor: Colors.white,
        ),
        home: Login());
  }
}*/