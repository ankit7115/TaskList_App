import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/todo.dart';
import 'package:todo/urls.dart';

class AddNote extends StatefulWidget {
  final Todo? todo;
  const AddNote({super.key, this.todo});
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _contentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titlecontroller.text = widget.todo!.title;
      _contentcontroller.text = widget.todo!.todo;
    }
  }
  Future<void> _addNote()async{
    final isUpdating = widget.todo != null;

    Todo note = Todo(
      id: widget.todo?.id,
      title: _titlecontroller.text,
      todo : _contentcontroller.text
    );
    try {
      final response = isUpdating ?  await http.put(
        updateUrl(id : note.id),
        headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(note.toMap()),
        ): 
      await http.post(
        createURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(note.toMap())
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        Navigator.pop(context,true);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(duration: Duration(seconds: 5),content: Text('Failed to create')),
        );
        throw Exception('Failed to add note');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(duration: Duration(seconds: 5),content: Text('Failed to create')),
      );
      throw Exception('Failed to add note');
      print(e);
    }
  }

  @override
  void dispose(){
    super.dispose();
    _titlecontroller.dispose();
    _contentcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Title',
                  ),
                  controller: _titlecontroller,
                ),
                const SizedBox(height: 50,),
                TextField(
                  decoration:const InputDecoration(
                    hintText: 'Content',
                  ),
                  controller: _contentcontroller,
                ),
                const SizedBox(height: 50,),
                TextButton(
                  onPressed: (){
                    if(!_titlecontroller.text.isEmpty && !_contentcontroller.text.isEmpty){
                      _addNote();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(duration: Duration(seconds: 3),content: Text('Please fill all the fields')),
                        
                        );
                    }
                  },
                  child: const Text("Submit"),
                  ),
              ],
            ),
          ),
          ),
      );
  }
}