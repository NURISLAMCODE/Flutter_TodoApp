import 'package:flutter/material.dart';
import 'package:todoapp/database_handler.dart';
import 'package:todoapp/home_screen.dart';
import 'package:todoapp/model.dart';

class AddScreen extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  bool? update;
  AddScreen(
      {super.key, this.todoTitle, this.todoDesc, this.update, this.todoId});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DatabaseHelper? databaseHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  loadData() async {
    dataList = databaseHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        // keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Note Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 5,
                        controller: descController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Desc Title"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_fromKey.currentState!.validate()) {
                              if (widget.update == true) {
                                databaseHelper!.update(TodoModel(
                                    id: widget.todoId,
                                    title: titleController.text,
                                    desc: descController.text));
                              } else {
                                databaseHelper!.insert(TodoModel(
                                    title: titleController.text,
                                    desc: descController.text));
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                              titleController.clear();
                              descController.clear();
                              // print("Data added");
                            }
                          });
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          titleController.clear();
                          descController.clear();
                        },
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
