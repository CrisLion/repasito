
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as dr;

class PeopleFavorite extends StatefulWidget {
  const PeopleFavorite({super.key});

  @override
  State<PeopleFavorite> createState() => _PeopleFavoriteState();
}

class _PeopleFavoriteState extends State<PeopleFavorite> {
  late Database database;
  

  @override
  Widget build(BuildContext context) {
    database = Provider.of<Database>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite people"),
      ),
      body: FutureBuilder<List<Favorite>>(
          future: database.getAllFavorites(),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              List<Favorite>? favoriteList = snapshot.data;
              return ListView.builder(
                itemCount: favoriteList!.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(favoriteList[index].photo),
                      ),
                      title: Text("${favoriteList[index].name} - ${favoriteList[index].gender}"),
                      subtitle: Text("City: ${favoriteList[index].city}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: (){
                          database.deleteFavorite(
                            FavoritesCompanion(
                              id: dr.Value(favoriteList[index].id),
                              name: dr.Value(favoriteList[index].name),
                              gender: dr.Value(favoriteList[index].gender),
                              city: dr.Value(favoriteList[index].city),
                              photo: dr.Value(favoriteList[index].photo) 
                            )
                          );
                          setState(() {
                            favoriteList.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
            return const Center(
              child: Text("Empty favorites"),
            );
          }
          },
        )
      );
  }
}