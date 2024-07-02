import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo/addnote.dart';
import 'package:todo/todo.dart'; // Ensure this imports the Note model
import 'package:todo/urls.dart'; // Ensure this imports the URLs

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Todo> notes = [];
  bool isLoading = true;
  bool hasError = false;

  Future<void>_updateNote({required Todo todo})async{
    var response = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNote(todo: todo)),
    );
    if(response == true){
      _retrieveNotes();
    }
  }
  Future<void> _deleteNote({int? id})async{
    try{
      final response = await http.delete(deleteUrl(id: id));
      if(response.statusCode == 200){
        setState(() {
          notes.removeWhere((element) => element.id == id);
        });
      }
    }
    catch(e){
      print(e);
    }
  }
  Future<void> _retrieveNotes() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body)['todos']; // Assuming 'todos' is the key for your list of notes
      setState(() {
        notes = responseData.map((data) => Todo.fromMap(data)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  } catch (e) {
    print(e);
    setState(() {
      hasError = true;
      isLoading = false;
    });
  }
}

@override
void initState() {
  super.initState();
  _retrieveNotes();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      drawer: DeveloperInfoDrawer(),
      body: RefreshIndicator(
        onRefresh: _retrieveNotes,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : hasError
                ? Center(child: Text("Failed to load notes."))
                : notes.isEmpty
                    ? Center(child: Text("No notes available."))
                    : Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              child: ListTile(
                                title: Text(note.title),
                                subtitle: Text(note.todo),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => _updateNote(todo: note),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => _deleteNote(id: note.id),
                                    ),
                                  ]
                            )));
                          },
                        ),
                    ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNote())).then((value){
            _retrieveNotes();
          });
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}
class DeveloperInfoDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 325,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[300],
            ),
            child: Text(
              'Developer Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // SizedBox(height: 500,),
          ListTile(
            title: Text('Developer: Ankit Srivastava'),
            onTap: () {
              // Add onTap functionality if needed
            },
          ),
          ListTile(
            title: Text('Contact Info: ankitsrivastav555@gmail.com'),
            onTap: () {
              // Add onTap functionality if needed
            },
          ),
        ],
      ),
    );
  }
}