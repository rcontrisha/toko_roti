import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:toko_roti/Modules/Dashboard%20Page/dashboard.dart';
import 'package:toko_roti/Modules/Kelola%20Akun%20Page/kelola_akun_view.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/Daftar%20Barang/daftar_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/Daftar%20Kategori/daftar_kategori.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/kelola_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Barang%20Page/pasok_barang.dart';
import 'package:toko_roti/Modules/Kelola%20Laporan%20Page/kelola_laporan.dart';
import 'package:toko_roti/Modules/Kelola%20Laporan%20Page/laporan_pegawai.dart';
import 'package:toko_roti/Modules/Kelola%20Laporan%20Page/laporan_transaksi.dart';
import 'package:toko_roti/Modules/Transaksi%20Page/transaksi.dart';

// Enum for Sidebar Items
enum SideBarItem {
  dashboard,
  kelolaakun,
  kelolabarang,
  transaksi,
  kelolalaporan,
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
      case 'kelolalaporan':
        return SideBarItem.kelolalaporan;
      case 'daftarkategori':
      case 'daftarbarang':
      case 'pasokbarang':
      case 'laporantransaksi':
      case 'laporanpegawai':
        return _selectedItem; // Keep the parent selected item for sub-routes
      default:
        return SideBarItem.dashboard;
    }
  }

  Widget _getSelectedScreen(String route) {
    switch (route) {
      case 'dashboard':
        _title = 'Dashboard';
        return DashboardScreen();
      case 'kelolaakun':
        _title = 'Kelola Akun';
        return KelolaAkun();
      case 'kelolabarang':
        _title = 'Kelola Barang';
        return KelolaBarang();
      case 'transaksi':
        _title = 'Transaksi';
        return Transaksi();
      case 'kelolalaporan':
        _title = 'Kelola Laporan';
        return KelolaLaporan();
      case 'daftarkategori':
        _title = 'Daftar Kategori';
        return DaftarKategori();
      case 'daftarbarang':
        _title = 'Daftar Barang';
        return DaftarBarang();
      case 'pasokbarang':
        _title = 'Pasok Barang';
        return PasokBarang();
      case 'laporantransaksi':
        _title = 'Laporan Transaksi';
        return LaporanTransaksi();
      case 'laporanpegawai':
        _title = 'Laporan Pegawai';
        return LaporanPegawai();
      default:
        _title = 'Dashboard';
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sideBarkey = ValueKey(Random().nextInt(1000000));

    return AdminScaffold(
      appBar: AppBar(
        key: UniqueKey(), // Menambahkan UniqueKey di sini
        title: Text(_title),
      ),
      sideBar: SideBar(
        key: sideBarkey,
        activeBackgroundColor: Colors.white,
        onSelected: (item) {
          final sideBarItem = _getSideBarItem(item.route!);
          setState(() {
            _selectedItem = sideBarItem;
            _selectedScreen = _getSelectedScreen(item.route!);
            _title = _getTitleForItem(item.route!); // Memperbarui judul di sini
          });
        },
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: 'dashboard',
          ),
          AdminMenuItem(
            title: 'Kelola Akun',
            icon: Icons.business,
            route: 'kelolaakun',
          ),
          AdminMenuItem(
            title: 'Kelola Barang',
            icon: Icons.group,
            route: 'kelolabarang',
            children: [
              AdminMenuItem(
                title: 'Daftar Kategori',
                route: 'daftarkategori',
              ),
              AdminMenuItem(
                title: 'Daftar Barang',
                route: 'daftarbarang',
              ),
              AdminMenuItem(
                title: 'Pasok Barang',
                route: 'pasokbarang',
              ),
            ],
          ),
          AdminMenuItem(
            title: 'Transaksi',
            icon: Icons.campaign,
            route: 'transaksi',
          ),
          AdminMenuItem(
            title: 'Kelola Laporan',
            icon: Icons.settings,
            route: 'kelolalaporan',
            children: [
              AdminMenuItem(
                title: 'Laporan Transaksi',
                route: 'laporantransaksi',
              ),
              AdminMenuItem(
                title: 'Laporan Pegawai',
                route: 'laporanpegawai',
              ),
            ],
          ),
        ],
        selectedRoute: _selectedItem.toString().split('.').last,
      ),
      body: _selectedScreen,
    );
  }

  String _getTitleForItem(String route) {
    switch (route) {
      case 'dashboard':
        return 'Dashboard';
      case 'kelolaakun':
        return 'Kelola Akun';
      case 'kelolabarang':
        return 'Kelola Barang';
      case 'transaksi':
        return 'Transaksi';
      case 'kelolalaporan':
        return 'Kelola Laporan';
      case 'daftarkategori':
        return 'Daftar Kategori';
      case 'daftarbarang':
        return 'Daftar Barang';
      case 'pasokbarang':
        return 'Pasok Barang';
      case 'laporantransaksi':
        return 'Laporan Transaksi';
      case 'laporanpegawai':
        return 'Laporan Pegawai';
      default:
        return 'Dashboard';
    }
  }
}
