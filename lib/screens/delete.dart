import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  final blog;

  DeleteDialog(this.blog);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  final dio = Dio();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text('delete')),
      content: Text('this is sontent ${widget.blog['name']}'),
      actions: [
        ElevatedButton(
            onPressed: () => deleteData(widget.blog['id']),
            child: Text('delete')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text('cancel'))
      ],
    );
  }

  void deleteData(String id) async {
    try {
      var response = await dio
          .delete('https://65cdc8f1c715428e8b3f0daf.mockapi.io/blog/${id}');
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
