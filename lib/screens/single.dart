import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SingleScreen extends StatefulWidget {
  final String id;
  SingleScreen(this.id);

  @override
  State<SingleScreen> createState() => _SingleScreenState();
}

class _SingleScreenState extends State<SingleScreen> {
  final dio = Dio();
  dynamic blogData = {};
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Page'),
        backgroundColor: Colors.amber,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: [
                  Image(
                      height: 250,
                      width: 250,
                      image: NetworkImage(blogData['avatar'] ?? 'nodata')),
                  Text(blogData['name'] ?? 'No data'),
                  Text(blogData['description'] ?? 'nodata')
                ],
              ),
            ),
    );
  }

  void getData(String id) async {
    try {
      print("object");
      var response = await dio
          .get('https://65cdc8f1c715428e8b3f0daf.mockapi.io/blog/${id}');
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          blogData = response.data;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
