import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/screen/register.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_image.dart';
import 'package:numfu/widgets/show_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel> _futureCustomer;

  @override
  void initState() {
    super.initState();
    _futureCustomer = _getCustomerData();
  }

  Future<UserModel> _getCustomerData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cust_email = preferences.getString('cust_email') ?? '';
    String apiGetCustomerData =
        '${MyCostant.domain}/api_numfu/getprofile.php?isAdd=true&cust_email=$cust_email';

    try {
      Response response = await Dio().get(apiGetCustomerData);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load customer data');
    }
  }

  Future<String?> _getProfileImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? cust_email = preferences.getString('cust_email');
    String apiGetProfileImage =
        '${MyCostant.domain}/api_numfu/getprofileimage.php?cust_email=$cust_email';

    try {
      Response response = await Dio().get(apiGetProfileImage);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load profile image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: FutureBuilder<UserModel>(
          future: _futureCustomer,
          builder: (context, snapshot) {
            final TextEditingController _firstnameController =
                TextEditingController();
            final TextEditingController _lastnameController =
                TextEditingController();
            final TextEditingController _emailController =
                TextEditingController();
            final TextEditingController _passwordController =
                TextEditingController();
            final TextEditingController _phoneController =
                TextEditingController();

            if (snapshot.hasData) {
              _firstnameController.text = snapshot.data!.cust_firstname;
              _lastnameController.text = snapshot.data!.cust_lastname;
              _emailController.text = snapshot.data!.cust_email;
              _passwordController.text = snapshot.data!.password;
              _phoneController.text = snapshot.data!.cust_phone;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _firstnameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อจริง',
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      labelText: 'นามสกุล',
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'อีเมล',
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'รหัส',
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'เบอร์โทร',
                      border: OutlineInputBorder(),
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<UserModel>(
                    future: _futureCustomer,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userModel = snapshot.data!;
                        if (userModel.profile_picture != null) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                '${MyCostant.domain}/${userModel.profile_picture}'),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(MyCostant.logo),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
