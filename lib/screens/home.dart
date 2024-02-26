import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rex/screens/add.dart';
import 'package:rex/screens/delete.dart';
import 'package:rex/screens/single.dart';
import 'edit.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Dio dio = Dio();
  bool isLoading = true;
  List<dynamic> blogs = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'FACEBOOK',
            style: TextStyle(color: Color.fromARGB(255, 230, 230, 230)),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 70, 0, 235),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                final id = blog["id"];
                final title = blog['name'] ?? 'No Title';
                final avatar = blog['avatar'] ?? '';
                final description = blog['description'] ?? '';

                return ListTile(
                  onTap: () => navigateToNextPageId(id),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(avatar),
                  ),
                  title: Text(title),
                  subtitle: Text(
                    description,
                    maxLines: 3,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          navigateToEditPage(blog);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => DeleteDialog(blog),
                          ).then((data) {
                            if (data == true) {
                              setState(() {
                                blogs.remove(blog);
                              });
                            }
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var blog = await showDialog(
            context: context,
            builder: (_) => AddBlog(),
          );

          if (blog != null) {
            setState(() {
              blogs.insert(0, blog);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToNextPageId(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SingleScreen(id)),
    );
  }

  void navigateToEditPage(dynamic blog) {
    showDialog(
      context: context,
      builder: (_) => EditBlog(blog),
    ).then((editedBlog) {
      if (editedBlog != null && editedBlog['id'] != null) {
        int index =
            blogs.indexWhere((element) => element['id'] == editedBlog['id']);
        if (index != -1) {
          setState(() {
            blogs[index] = editedBlog;
          });
        } else {
          print('Blog not found in the list.');
        }
      } else {
        print('Invalid edited blog data.');
      }
    });
  }

  Future<void> getData() async {
    try {
      var response =
          await dio.get('https://65cdc8f1c715428e8b3f0daf.mockapi.io/blog');
      if (response.statusCode == 200) {
        setState(() {
          blogs = response.data;
          isLoading = false;
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
