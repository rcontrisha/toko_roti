import 'package:flutter/material.dart';

class DaftarKategori extends StatelessWidget {
  const DaftarKategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Text(
          'Daftar Kategori Screen',
          style: TextStyle(fontSize: 24, color: Colors.blue),
        ),
      ),
    );
  }
}
