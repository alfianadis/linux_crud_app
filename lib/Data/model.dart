class Person {
  final int id;
  final String nama;
  final String jenisKelamin;
  final String tanggalLahir;
  final String alamat;

  Person({
    required this.id,
    required this.nama,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.alamat,
  });

  // Konversi dari JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      nama: json['nama'],
      jenisKelamin: json['jenisKelamin'],
      tanggalLahir: json['tanggalLahir'],
      alamat: json['alamat'],
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jenisKelamin': jenisKelamin,
      'tanggalLahir': tanggalLahir,
      'alamat': alamat,
    };
  }
}
