import 'package:flutter/material.dart';
import 'package:linux_crud_app/Data/model.dart';
import 'package:linux_crud_app/Data/service.dart';
import 'package:linux_crud_app/colors.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String selectedDate = '';
  String selectedGender = '';
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Konversi String ke DateTime
      DateTime? selected = DateTime.tryParse(selectedDate);

      if (selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tanggal lahir tidak valid")),
        );
        return;
      }

      final person = PersonModel(
        id: 0,
        nama: _nameController.text,
        jenisKelamin: selectedGender,
        tanggalLahir: selected, // Ini bertipe DateTime
        alamat: _addressController.text,
      );

      try {
        final success = await _apiService.addPerson(person);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil ditambahkan")),
          );
          _formKey.currentState!.reset();
          setState(() {
            selectedDate = '';
            selectedGender = '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menambahkan data")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Field
                _buildTextField(
                  label: 'Nama',
                  controller: _nameController,
                  hint: "Masukkan Nama Anda",
                  validator:
                      (value) =>
                          value!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                const SizedBox(height: 10),

                // Jenis Kelamin Field
                const Text(
                  'Jenis Kelamin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Laki-laki'),
                        value: 'Laki-Laki',
                        groupValue: selectedGender,
                        onChanged:
                            (value) => setState(() {
                              selectedGender = value!;
                            }),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Perempuan'),
                        value: 'Perempuan',
                        groupValue: selectedGender,
                        onChanged:
                            (value) => setState(() {
                              selectedGender = value!;
                            }),
                      ),
                    ),
                  ],
                ),
                if (selectedGender.isEmpty)
                  const Text(
                    "Pilih jenis kelamin",
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),

                // Tanggal Lahir Field
                _buildDatePicker(context),

                const SizedBox(height: 10),

                // Alamat Field
                _buildTextField(
                  label: 'Alamat',
                  controller: _addressController,
                  hint: "Masukkan Alamat Anda",
                  maxLines: 3,
                  validator:
                      (value) =>
                          value!.isEmpty ? "Alamat tidak boleh kosong" : null,
                ),
                const SizedBox(height: 30),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Submit Data',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate.toIso8601String();
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          hintText: selectedDate.isEmpty ? 'Pilih Tanggal' : null,
        ),
        child: Text(
          selectedDate.isEmpty ? 'Pilih Tanggal' : selectedDate,
          style: TextStyle(
            color: selectedDate.isEmpty ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}
