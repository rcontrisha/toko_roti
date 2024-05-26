import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/Services/api_services.dart';

class HakAksesPage extends StatefulWidget {
  @override
  _HakAksesPageState createState() => _HakAksesPageState();
}

class _HakAksesPageState extends State<HakAksesPage> {
  late List<Map<String, dynamic>> _userAccessList = [];
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _fetchUserAccess();
  }

  Future<void> _fetchUserAccess() async {
    try {
      final List<dynamic> userAccessList =
          await _apiService.fetchAccessRights();
      final List<Map<String, dynamic>> mappedUserAccessList =
          List<Map<String, dynamic>>.from(userAccessList);
      setState(() {
        _userAccessList = mappedUserAccessList;
      });
    } catch (e) {
      print('Error fetching user access: $e');
    }
  }

  Future<void> _updateAccessRight(
      String username, String key, bool value) async {
    final updatedAccessRight = {
      key: value ? 1 : 0,
    };

    try {
      print(username);
      print(value);
      await _apiService.updateAccessRight(username, updatedAccessRight);
      print('Access right updated successfully');
      // Memperbarui daftar akses pengguna setelah berhasil memperbarui akses
      await _fetchUserAccess();
    } catch (e) {
      print('Failed to update access right: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Mengatur arah scroll menjadi vertikal
        child: Center(
          // Menggunakan Center untuk membuat tabel menjadi terpusat
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DataTable(
                  columns: [
                    DataColumn(label: Text('Nama Akun')),
                    DataColumn(label: Text('Kelola Akun')),
                    DataColumn(label: Text('Kelola Barang')),
                    DataColumn(label: Text('Kelola Transaksi')),
                    DataColumn(label: Text('Kelola Laporan')),
                  ],
                  rows: _userAccessList.map((access) {
                    return DataRow(cells: [
                      DataCell(Text(access['username'])),
                      DataCell(
                        Checkbox(
                          activeColor: Colors.greenAccent[700],
                          value: access['can_manage_account'] == 1,
                          onChanged: (value) {
                            _updateAccessRight(access['username'],
                                'can_manage_account', value ?? false);
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          activeColor: Colors.greenAccent[700],
                          value: access['can_manage_items'] == 1,
                          onChanged: (value) {
                            _updateAccessRight(access['username'],
                                'can_manage_items', value ?? false);
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          activeColor: Colors.greenAccent[700],
                          value: access['can_manage_transactions'] == 1,
                          onChanged: (value) {
                            _updateAccessRight(access['username'],
                                'can_manage_transactions', value ?? false);
                          },
                        ),
                      ),
                      DataCell(
                        Checkbox(
                          activeColor: Colors.greenAccent[700],
                          value: access['can_manage_reports'] == 1,
                          onChanged: (value) {
                            _updateAccessRight(access['username'],
                                'can_manage_reports', value ?? false);
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
