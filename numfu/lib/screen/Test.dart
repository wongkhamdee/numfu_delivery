import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:numfu/utility/my_constant.dart';

Future<List<Map<String, dynamic>>> fetchRestaurants() async {
  final response =
      await http.get(Uri.parse('${MyCostant.domain}/api_numfu/Apiget.php'));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(jsonData);
  } else {
    throw Exception('Failed to load restaurants');
  }
}

Future<String> fetchRestaurantImage(String resId) async {
  final response = await http.get(Uri.parse(
      '${MyCostant.domain}/api_numfu/getimgres.php?isAdd=true&res_id=$resId'));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['company_logo'];
  } else {
    throw Exception('Failed to load restaurant image');
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchRestaurants(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final restaurants = snapshot.data!;
            return PageView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Container(
                  width: 250,
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                              '${MyCostant.domain}/${restaurant['company_logo']}'),
                          title: Text(restaurant['res_name']),
                          subtitle: Text(restaurant['owner_name']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurant['owner_name'],
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RestaurantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantDetailScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant['res_name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Restaurant Name: ${restaurant['res_name']}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Owner Name: ${restaurant['owner_name']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Phone Number: ${restaurant['phone_number']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            FutureBuilder<String?>(
              future: fetchRestaurantImage(restaurant['res_id']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final imagePath = snapshot.data!;
                  if (imagePath.isNotEmpty) {
                    return Image.network(
                      '${MyCostant.domain}/$imagePath',
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  }
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
