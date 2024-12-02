import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linux_crud_app/Data/model.dart';

class PersonService {
  final String baseUrl = 'http://localhost:3000/person';

  Future<List<Person>> getAllPersons() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Person.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch persons');
    }
  }

  Future<Person> getPersonById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Person.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch person');
    }
  }

  Future<void> createPerson(Person person) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(person.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create person');
    }
  }

  Future<void> updatePerson(int id, Person person) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(person.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update person');
    }
  }

  Future<void> deletePerson(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete person');
    }
  }
}
