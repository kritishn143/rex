import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final dio = Dio();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final avatarCotroller = TextEditingController();
  bool isLoading = false;

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    avatarCotroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('add Blog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'name'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'description'),
          ),
          TextFormField(
            controller: avatarCotroller,
            decoration: InputDecoration(labelText: 'avatar'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              var data = {
                "name": nameController.text,
                "description": descriptionController.text,
                "avatar": avatarCotroller.text,
              };
              addData(data);
            },
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text("add"))
      ],
    );
  }

  void addData(Map data) async {
    setState(() {
      isLoading = true;
    });
    var response = await dio
        .post('https://65cdc8f1c715428e8b3f0daf.mockapi.io/blog', data: data);
    if (response.statusCode == 201) {
      Navigator.pop(context, response.data);
    }
  }
}
