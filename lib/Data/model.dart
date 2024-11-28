class FormData {
  int? id;
  String name;
  String gender;
  String date;
  String address;
  String imagePath;

  FormData({
    this.id,
    required this.name,
    required this.gender,
    required this.date,
    required this.address,
    required this.imagePath,
  });

  factory FormData.fromMap(Map<String, dynamic> json) => FormData(
    id: json['id'],
    name: json['name'],
    gender: json['gender'],
    date: json['date'],
    address: json['address'],
    imagePath: json['imagePath'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'date': date,
      'address': address,
      'imagePath': imagePath,
    };
  }
}
