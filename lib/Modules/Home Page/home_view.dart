import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:toko_roti/Modules/Dashboard%20Page/dashboard.dart';
import 'package:toko_roti/Modules/Kelola%20Akun%20Page/kelola_akun_view.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/Daftar%20Barang/daftar_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/Daftar%20Kategori/daftar_kategori.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/kelola_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/pasok_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Laporan%20Page/laporan_transaksi.dart';
import 'package:toko_roti/Modules/Transaksi%20Page/transaksi.dart';

// Enum for Sidebar Items
enum SideBarItem {
  dashboard,
  kelolaakun,
  kelolabarang,
  transaksi,
  laporantransaksi,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SideBarItem _selectedItem;
  late Widget _selectedScreen;
  late String _title;

  @override
  void initState() {
    super.initState();
    _selectedItem = SideBarItem.dashboard;
    _selectedScreen = DashboardScreen();
    _title = 'Dashboard'; // Initialize the title here
    print('Init State - Title: $_title'); // Logging
  }

  SideBarItem _getSideBarItem(String route) {
    switch (route) {
      case 'dashboard':
        return SideBarItem.dashboard;
      case 'kelolaakun':
        return SideBarItem.kelolaakun;
      case 'kelolabarang':
        return SideBarItem.kelolabarang;
      case 'transaksi':
        return SideBarItem.transaksi;
      case 'laporantransaksi':
        return SideBarItem.laporantransaksi;
      case 'daftarkategori':
      case 'daftarbarang':
      case 'pasokbarang':
        return _selectedItem; // Keep the parent selected item for sub-routes
      default:
        return SideBarItem.dashboard;
    }
  }

  Widget _getSelectedScreen(String route) {
    switch (route) {
      case 'dashboard':
        _title = 'Dashboard';
        break;
      case 'kelolaakun':
        _title = 'Kelola Akun';
        break;
      case 'kelolabarang':
        _title = 'Kelola Barang';
        break;
      case 'transaksi':
        _title = 'Transaksi';
        break;
      case 'laporantransaksi':
        _title = 'Laporan Transaksi';
        break;
      case 'daftarkategori':
        _title = 'Daftar Kategori';
        break;
      case 'daftarbarang':
        _title = 'Daftar Barang';
        break;
      case 'pasokbarang':
        _title = 'Pasok Barang';
        break;
      default:
        _title = 'Dashboard';
    }
    print('Selected Screen - Title: $_title'); // Logging

    switch (route) {
      case 'dashboard':
        return DashboardScreen();
      case 'kelolaakun':
        return KelolaAkun();
      case 'kelolabarang':
        return KelolaBarang();
      case 'transaksi':
        return Transaksi();
      case 'laporantransaksi':
        return LaporanTransaksi();
      case 'daftarkategori':
        return DaftarKategori();
      case 'daftarbarang':
        return DaftarBarang();
      case 'pasokbarang':
        return PasokBarang();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Dashboard',
              route: 'dashboard',
            ),
            _buildDrawerItem(
              icon: Icons.business,
              text: 'Kelola Akun',
              route: 'kelolaakun',
            ),
            ExpansionTile(
              leading: Icon(Icons.group),
              title: Text('Kelola Barang'),
              children: [
                _buildDrawerItem(
                  text: 'Daftar Kategori',
                  route: 'daftarkategori',
                ),
                _buildDrawerItem(
                  text: 'Daftar Barang',
                  route: 'daftarbarang',
                ),
                _buildDrawerItem(
                  text: 'Pasok Barang',
                  route: 'pasokbarang',
                ),
              ],
            ),
            _buildDrawerItem(
              icon: Icons.campaign,
              text: 'Transaksi',
              route: 'transaksi',
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              text: 'Laporan Transaksi',
              route: 'laporantransaksi',
            ),
          ],
        ),
      ),
      body: _selectedScreen,
    );
  }

  Widget _buildDrawerItem({
    IconData? icon,
    required String text,
    required String route,
  }) {
    final bool selected = _selectedItem == _getSideBarItem(route);
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () {
        _onSelected(route);
      },
    );
  }

  void _onSelected(String route) {
    final sideBarItem = _getSideBarItem(route);
    setState(() {
      _selectedItem = sideBarItem;
      _selectedScreen = _getSelectedScreen(route);
    });
  }
}
