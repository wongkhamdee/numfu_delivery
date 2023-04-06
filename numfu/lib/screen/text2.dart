import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/screen/register.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_image.dart';
import 'package:numfu/widgets/show_title.dart';

class ProfilePage2 extends StatefulWidget {
  const ProfilePage2({Key? key}) : super(key: key);

  @override
  _ProfilePage2State createState() => _ProfilePage2State();
}

class _ProfilePage2State extends State<ProfilePage2> {
  late Future<UserModel> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = getUserProfile();
  }

  Future<UserModel> getUserProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cust_email = preferences.getString('email') ?? '';
    var response = await http.get(
      Uri.parse(
          '${MyCostant.domain}/api_numfu/getprofile.php?isAdd=true&cust_email=$cust_email'),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      UserModel userModel = UserModel.fromJson(data[0]);
      return userModel;
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel userModel = snapshot.data!;
            return Column(
              children: [
                Image.network(
                  '${MyCostant.domain}/api_numfu/getprofileimage.php?isAdd=true&cust_email=${userModel.cust_email}',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                    'Name: ${userModel.cust_firstname} ${userModel.cust_lastname}'),
                Text('Phone: ${userModel.cust_phone}'),
                Text('Email: ${userModel.cust_email}'),
                Text('Address: ${userModel.address}'),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
