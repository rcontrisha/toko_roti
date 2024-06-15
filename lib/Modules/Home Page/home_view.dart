import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/Modules/Dashboard%20Page/dashboard.dart';
import 'package:toko_roti/Modules/Kelola%20Akun%20Page/daftar_akun.dart';
import 'package:toko_roti/Modules/Kelola%20Akun%20Page/hak_akses.dart';
import 'package:toko_roti/Modules/Laporan%20Transaksi%20Page/laporan_transaksi.dart';
import 'package:toko_roti/Modules/Login%20Page/login_screen.dart';
import 'package:toko_roti/Modules/Transaksi%20Page/transaksi.dart';
import 'package:toko_roti/Modules/Transaksi%20Page/transaksi_user.dart';

enum SideBarItem {
  dashboard,
  daftarakun,
  hakakses,
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
  late String _username;
  bool _canManageAccount = false;
  bool _canManageItems = false;
  bool _canManageTransactions = false;
  bool _canManageReports = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = SideBarItem.dashboard;
    _selectedScreen = DashboardPage();
    _title = 'Dashboard';
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('nama_user') ?? '';
      _canManageAccount = prefs.getBool('can_manage_account') ?? false;
      _canManageItems = prefs.getBool('can_manage_items') ?? false;
      _canManageTransactions =
          prefs.getBool('can_manage_transactions') ?? false;
      _canManageReports = prefs.getBool('can_manage_reports') ?? false;
    });
  }

  SideBarItem _getSideBarItem(String route) {
    switch (route) {
      case 'dashboard':
        return SideBarItem.dashboard;
      case 'daftarakun':
        return SideBarItem.daftarakun;
      case 'hakakses':
        return SideBarItem.hakakses;
      case 'transaksi':
        return SideBarItem.transaksi;
      case 'laporantransaksi':
        return SideBarItem.laporantransaksi;
      default:
        return SideBarItem.dashboard;
    }
  }

  Widget _getSelectedScreen(String route) {
    switch (route) {
      case 'dashboard':
        _title = 'Dashboard';
        return DashboardPage();
      case 'daftarakun':
        _title = 'Daftar Akun';
        if (_canManageAccount) {
          return DaftarAkun();
        }
        break;
      case 'hakakses':
        _title = 'Hak Akses';
        if (_canManageAccount) {
          return HakAksesPage();
        }
        break;
      case 'transaksi':
        _title = 'Transaksi';
        if (_canManageTransactions) {
          return Transaksi();
        }
        return TransaksiUser();
      case 'laporantransaksi':
        _title = 'Laporan Transaksi';
        if (_canManageReports) {
          return LaporanTransaksi();
        }
        break;
      default:
        _title = 'Dashboard';
        return DashboardPage();
    }
    return Container(
      child: Center(
          child: Text('Anda tidak memiliki hak untuk mengakses halaman ini.')),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('nama_user');
    await prefs.remove('can_manage_account');
    await prefs.remove('can_manage_items');
    await prefs.remove('can_manage_transactions');
    await prefs.remove('can_manage_reports');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onSelected(String route) {
    setState(() {
      _selectedItem = _getSideBarItem(route);
      _selectedScreen = _getSelectedScreen(route);
    });
    if (!_checkAccess(route)) {
      _showAccessDeniedDialog();
    }
  }

  bool _checkAccess(String route) {
    switch (route) {
      case 'dashboard':
        return true;
      case 'daftarakun':
        return _canManageAccount;
      case 'hakakses':
        return _canManageAccount;
      case 'transaksi':
        return true; // Transaksi is accessible by all users
      case 'laporantransaksi':
        return _canManageReports;
      default:
        return false;
    }
  }

  void _showAccessDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Akses Ditolak"),
          content: Text("Anda tidak memiliki hak untuk mengakses halaman ini."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.greenAccent[400],
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.person),
            onSelected: (String value) {
              if (value == 'logout') {
                _logOut();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'user',
                  child: Text(_username),
                ),
                PopupMenuDivider(height: 1),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the popup menu
                      _logOut();
                    },
                    child: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent[400],
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
            ExpansionTile(
              iconColor: Colors.greenAccent[400],
              leading: Icon(
                Icons.business,
                color: (_selectedItem == SideBarItem.daftarakun ||
                        _selectedItem == SideBarItem.hakakses)
                    ? Colors.greenAccent[400]
                    : Colors.black,
              ),
              title: Text(
                'Kelola Akun',
                style: TextStyle(
                  color: (_selectedItem == SideBarItem.daftarakun ||
                          _selectedItem == SideBarItem.hakakses)
                      ? Colors.greenAccent[400]
                      : Colors.black,
                  fontWeight: (_selectedItem == SideBarItem.daftarakun ||
                          _selectedItem == SideBarItem.hakakses)
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              children: [
                _buildDrawerItem(
                  text: 'Daftar Akun',
                  route: 'daftarakun',
                ),
                _buildDrawerItem(
                  text: 'Hak Akses',
                  route: 'hakakses',
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
    final Color iconColor = selected ? Colors.greenAccent : Colors.black;
    return ListTile(
      leading: icon != null ? Icon(icon, color: iconColor) : null,
      title: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.greenAccent[400] : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () {
        _onSelected(route);
      },
    );
  }
}
