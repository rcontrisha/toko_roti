import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_roti/Modules/Home%20Page/home_view.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Bakery Admin',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(), // Menggunakan HomePage sebagai halaman utama
      ),
    ),
  );
}
