import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:linux_crud_app/colors.dart';
import 'package:linux_crud_app/mainscreen.dart';
import 'package:http/http.dart' as http;

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // final ImagePicker _picker = ImagePicker();
  // File? _imageFile;

  String selectedDate = '';
  String? selectedGender;
  // String _currentAddress = '';

  // Future<void> _pickImage(ImageSource source) async {
  //   final XFile? pickedFile = await _picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          'Form Penambahan Data',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Nama',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Container(
                height: size.height * 0.09,
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.greenSecobdColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: TextFormField(
                    controller: _nameController,
                    onChanged: (value) {},
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Masukkan Nama Anda",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 12,
                        color: AppColors.greySixColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Laki-laki',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Radio<String>(
                        value: 'Laki-Laki',
                        groupValue: selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Perempuan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Radio<String>(
                        value: 'Perempuan',
                        groupValue: selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Tanggal Lahir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate:
                        DateTime.now(), // Membatasi pemilihan tanggal hingga hari ini
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate =
                          "${pickedDate.year.toString().padLeft(4, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                child: Container(
                  height: size.height * 0.09,
                  width: size.width,
                  padding: const EdgeInsets.only(left: 20, right: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.greenSecobdColor,
                    border: Border.all(
                      color: AppColors.greySecondColor,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.62,
                        child: Text(
                          selectedDate.isNotEmpty
                              ? selectedDate
                              : 'Masukkan Tanggal',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                selectedDate.isNotEmpty
                                    ? FontWeight.bold
                                    : FontWeight.w200,
                            color:
                                selectedDate.isNotEmpty
                                    ? AppColors.neutralColor
                                    : AppColors.greySixColor,
                          ),
                        ),
                      ),
                      selectedDate.isNotEmpty
                          ? InkWell(
                            onTap: () {
                              setState(() {
                                selectedDate = '';
                              });
                            },
                            child: SvgPicture.asset(
                              'assets/icons/cross.svg',
                              width: 20,
                              height: 20,
                              color: AppColors.neutralColor,
                            ),
                          )
                          : SvgPicture.asset(
                            'assets/icons/arrow-down.svg',
                            width: 15,
                            height: 15,
                            color: AppColors.neutralColor,
                          ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Alamat',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: size.height * 0.15,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 8),
                      child: TextFormField(
                        controller: _addressController,
                        onChanged: (value) {},
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Masukkan Alamat Anda",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
                            color: AppColors.greySixColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //button submit
              Center(
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black,
                  ),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      _submitData();
                    },
                    child: const Center(
                      child: Text(
                        'Submit Data',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppColors.whiteTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (_nameController.text.isEmpty ||
        selectedGender == null ||
        selectedDate.isEmpty ||
        _addressController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Validasi Gagal"),
              content: Text("Semua bidang harus diisi!"),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          'http://<backend-url>/person',
        ), // Ganti dengan URL backend Anda
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': _nameController.text,
          'jenisKelamin': selectedGender,
          'tanggalLahir': selectedDate,
          'alamat': _addressController.text,
        }),
      );

      if (response.statusCode == 201) {
        // Tampilkan alert berhasil
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Berhasil"),
                content: const Text("Data berhasil disimpan!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        // Tampilkan alert jika gagal
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("Gagal"),
              content: Text("Terjadi kesalahan saat menyimpan data: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }
}
