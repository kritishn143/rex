import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBlog extends StatefulWidget {
  final dynamic blog;

  EditBlog(this.blog);

  @override
  _EditBlogState createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _avatarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.blog['name'];
    _descriptionController.text = widget.blog['description'];
    _avatarController.text = widget.blog['avatar'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Blog'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _avatarController,
            decoration: InputDecoration(labelText: 'Avatar URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog without saving changes
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Save changes and update blog post
            _updateBlogPost();
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _updateBlogPost() async {
    // Prepare the data to be sent to the backend
    Map<String, dynamic> updatedData = {
      'name': _titleController.text,
      'description': _descriptionController.text,
      'avatar': _avatarController.text,
      // You may need to include other fields here
    };

    // Make the API request to update the blog post
    var response = await http.put(
      Uri.parse(
          'https://65cdc8f1c715428e8b3f0daf.mockapi.io/blog/${widget.blog['id']}'),
      body: updatedData,
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Blog post updated successfully
      // You may want to display a message to the user or navigate back to the previous screen
      print('Blog post updated successfully');
    } else {
      // Failed to update blog post
      // You may want to display an error message to the user
      print('Failed to update blog post');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _avatarController.dispose();
    super.dispose();
  }
}
