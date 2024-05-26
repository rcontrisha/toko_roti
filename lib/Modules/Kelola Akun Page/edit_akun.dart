import 'package:flutter/material.dart';
import 'package:toko_roti/Services/api_services.dart';

class EditAkun extends StatefulWidget {
  final Map<String, dynamic> akun;

  EditAkun({required this.akun});

  @override
  _EditAkunState createState() => _EditAkunState();
}

class _EditAkunState extends State<EditAkun> {
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _posisiController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.akun['nama_user']);
    _emailController = TextEditingController(text: widget.akun['email']);
    _usernameController = TextEditingController(text: widget.akun['username']);
    _passwordController = TextEditingController(text: widget.akun['password']);
    _posisiController = TextEditingController(text: widget.akun['posisi']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Akun'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama User'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: _posisiController,
              decoration: InputDecoration(labelText: 'Posisi'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Log nilai ID akun
    print('Akun ID: ${widget.akun['id']}');
    print('Password: ${widget.akun['password']}');

    // Membuat payload data untuk pembaruan akun
    Map<String, dynamic> updatedAkun = {
      'nama_user': _namaController.text,
      'email': _emailController.text,
      'username': _usernameController.text,
      'posisi': _posisiController.text,
    };

    // Memeriksa apakah field edit password tidak diisi
    if (_passwordController.text.isNotEmpty) {
      // Jika tidak ada perubahan pada field edit password, gunakan password sebelumnya
      updatedAkun['password'] = _passwordController.text;
    }

    // Log payload data sebelum dikirim
    print('Payload Data: $updatedAkun');

    try {
      // Memanggil metode updateAkun dari ApiService
      await ApiService().updateAkun(widget.akun['id'], updatedAkun);
      Navigator.pop(
          context, true); // Kembalikan true sebagai hasil edit berhasil
    } catch (e) {
      // Menampilkan pesan kesalahan jika pembaruan gagal
      print('Failed to update akun: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update akun')),
      );
    }
  }
}
