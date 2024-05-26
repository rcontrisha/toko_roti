import 'package:flutter/material.dart';
import 'package:toko_roti/Services/api_services.dart';

class TambahAkun extends StatefulWidget {
  @override
  _TambahAkunState createState() => _TambahAkunState();
}

class _TambahAkunState extends State<TambahAkun> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _posisiController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> akun = {
        'nama_user': _namaController.text,
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'posisi': _posisiController.text,
      };

      try {
        await ApiService().createAkun(akun);
        Navigator.pop(context); // Return to previous screen
      } catch (e) {
        print('Failed to create akun: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create akun')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Akun')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama User'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _posisiController,
                decoration: InputDecoration(labelText: 'Posisi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter posisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Tambah Akun'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
