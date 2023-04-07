import 'package:flutter/material.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/login.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Launcher();
          } else {
            return Login();
          }
        },
      ),
    );
  }
}
