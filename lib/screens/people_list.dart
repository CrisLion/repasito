import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_application_1/database/database.dart';
import 'package:flutter_application_1/model/people_model.dart';
import 'package:flutter_application_1/provider/api_provider.dart';
import 'package:flutter_application_1/screens/people_favorite.dart';
import 'package:provider/provider.dart';

class PeopleList extends StatefulWidget {
  const PeopleList({super.key});

  @override
  State<PeopleList> createState() => _PeopleListState();
}

class _PeopleListState extends State<PeopleList> {
  late Database database;
  ApiProvider api = ApiProvider();
  List<Results> data = [];

  Future<void> getPeople(int quantity) async {
    var people = await api.getPeople(quantity);
    setState(() {
      data = people;
    });
  }

  @override
  void initState(){
    //getPeople(10);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController quantityController = TextEditingController();
    database = Provider.of<Database>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('People List'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: quantityController,
                decoration: new InputDecoration(labelText: "Enter the quantity of people"),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                color: Colors.blue,
                child: IconButton(
                  onPressed: () {
                    if (data.isNotEmpty){
                      data.clear();
                    }
                    getPeople(int.parse(quantityController.text));
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.send)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                color: Colors.red,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => PeopleFavorite()));
                  },
                  color: Colors.white,
                  icon: const Icon(Icons.favorite)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(data[index].picture!.thumbnail!),
                      ),
                      title: Text("${data[index].name!.first!} ${data[index].name!.last!}"),
                      subtitle: Text("Email: ${data[index].email}\nCity: ${data[index].location!.city!}\nCelphone: ${data[index].cell}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () {
                          database.insertFavorite(FavoritesCompanion(
                            name: dr.Value(data[index].name!.first!),
                            gender: dr.Value(data[index].gender!),
                            city: dr.Value(data[index].location!.city!),
                            photo: dr.Value(data[index].picture!.thumbnail!)
                          )).then((value) {
                            if (value > 0){
                              ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                content: Text("Added to favorite"),
                                duration: Duration(milliseconds: 600),
                              )
                              );
                              setState(() {
                                data.removeAt(index);
                              });
                            } 
                          })
                          ;
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
