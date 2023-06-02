import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todoapp/add_screen.dart';
import 'package:todoapp/database_handler.dart';
import 'package:todoapp/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper? databaseHelper;
  late Future<List<TodoModel>> dataList;

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
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          "Todo App",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.access_alarm_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: dataList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TodoModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.length == 0) {
                  return Center(
                    child: Text("No Task Found"),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todoitle = snapshot.data![index].title.toString();
                      String todoDesc = snapshot.data![index].desc.toString();

                      return Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.yellow.shade200,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  spreadRadius: 1),
                            ]),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(8),
                              title: Text(
                                todoitle,
                                style: TextStyle(fontSize: 19),
                              ),
                              subtitle: Text(
                                todoDesc,
                                style: TextStyle(fontSize: 17),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddScreen(
                                                todoId: todoId,
                                                todoTitle: todoitle,
                                                todoDesc: todoDesc,
                                                update: true,
                                              ),
                                            ));
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        databaseHelper!.delete(todoId);
                                        dataList =
                                            databaseHelper!.getDataList();
                                        snapshot.data!
                                            .remove(snapshot.data![index]);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
    ;
  }
}
