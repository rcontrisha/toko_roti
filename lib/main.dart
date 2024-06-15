import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toko_roti/Modules/Home%20Page/home_view.dart';
import 'package:toko_roti/Modules/Login%20Page/login_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bakery Admin',
        home: LoginPage(), // Menggunakan HomePage sebagai halaman utama
      ),
    ),
  );
}
