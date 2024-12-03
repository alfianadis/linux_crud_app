import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:linux_crud_app/Data/model.dart';

class ApiService {
  final String baseUrl = "https://example.com/api";

  // Fungsi untuk mengirim data ke API
  Future<bool> addPerson(PersonModel person) async {
    final url = Uri.parse("$baseUrl/person");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: personModelToJson(person),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Error: ${response.body}");
      return false;
    }
  }

  // Fungsi untuk mengambil data dari API
  Future<List<PersonModel>> fetchPersons() async {
    final url = Uri.parse("$baseUrl/person");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => PersonModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
