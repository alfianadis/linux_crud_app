import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linux_crud_app/Data/model.dart';
import 'package:linux_crud_app/colors.dart';
import 'package:linux_crud_app/detail_output.dart';

class OutputForm extends StatefulWidget {
  const OutputForm({super.key});

  @override
  State<OutputForm> createState() => _OutputFormState();
}

class _OutputFormState extends State<OutputForm> {
  List<Person> _formDataList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://<backend-url>/person',
        ), // Ganti dengan URL backend Anda
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _formDataList =
              data
                  .map((item) => Person.fromJson(item))
                  .toList(); // Konversi JSON ke daftar objek Person
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Terjadi kesalahan saat memuat data: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _deleteData(int id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          'http://<backend-url>/person/$id',
        ), // Ganti dengan URL backend Anda
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        _fetchData(); // Refresh data setelah penghapusan
      } else {
        throw Exception('Gagal menghapus data');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Error"),
              content: Text("Terjadi kesalahan saat menghapus data: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 23,
            color: AppColors.neutralColor,
          ),
        ),
        title: const Text(
          'List Data',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _formDataList.isEmpty
              ? const Center(
                child: Text(
                  'Belum Ada Data\nSilahkan Input Data Dahulu Pada Form Entry',
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                itemCount: _formDataList.length,
                itemBuilder: (context, index) {
                  final item = _formDataList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          item.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Alamat: ${item.alamat}'),
                            Text('Tanggal Lahir: ${item.tanggalLahir}'),
                            Text('Jenis Kelamin: ${item.jenisKelamin}'),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailOutput(formData: item),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text("Hapus Data"),
                                    content: const Text(
                                      "Apakah Anda yakin ingin menghapus data ini?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Batal"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteData(item.id!);
                                        },
                                        child: const Text("Hapus"),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
