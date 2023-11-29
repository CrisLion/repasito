import "package:flutter_application_1/model/people_model.dart";
import 'package:http/http.dart' as http;

class ApiProvider {
  final url = "https://randomuser.me";
  List<Results> _people = [];

  Future<List<Results>> getPeople(int quantity) async {
    final response = await http.get(Uri.parse("$url/api/?results=$quantity"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load data");
    } else {
      print(response.body);
      final peopleResponse = peopleResponseFromJson(response.body);
      print(peopleResponse);
      _people.addAll(peopleResponse.results!);
    }
    return _people;
  }
}
