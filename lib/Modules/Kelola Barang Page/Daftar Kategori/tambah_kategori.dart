import 'package:flutter/material.dart';
import '../../../Services/api_services.dart';

class TambahKategori extends StatefulWidget {
  const TambahKategori({Key? key}) : super(key: key);

  @override
  _TambahKategoriState createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  final TextEditingController _namaController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _tambahKategori() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lakukan penambahan kategori menggunakan ApiService
      await _apiService.createKategori({'nama_kategori': _namaController.text});

      // Perbarui data daftar kategori pada halaman DaftarKategori
      Navigator.pop(context, true);
    } catch (error) {
      // Handle error
      print('Error: $error');
      // Tampilkan pesan error jika diperlukan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to add category. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Kategori',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _tambahKategori,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }
}
