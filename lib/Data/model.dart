// To parse this JSON data, do
//
//     final personModel = personModelFromJson(jsonString);

import 'dart:convert';

PersonModel personModelFromJson(String str) =>
    PersonModel.fromJson(json.decode(str));

String personModelToJson(PersonModel data) => json.encode(data.toJson());

class PersonModel {
  int id;
  String nama;
  String jenisKelamin;
  DateTime tanggalLahir;
  String alamat;

  PersonModel({
    required this.id,
    required this.nama,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.alamat,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
    id: json["id"],
    nama: json["nama"],
    jenisKelamin: json["jenisKelamin"],
    tanggalLahir: DateTime.parse(json["tanggalLahir"]),
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "jenisKelamin": jenisKelamin,
    "tanggalLahir":
        "${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}",
    "alamat": alamat,
  };
}
