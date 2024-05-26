import 'package:flutter/material.dart';
import 'package:toko_roti/Modules/Kelola%20Akun%20Page/edit_akun.dart';
import 'package:toko_roti/Services/api_services.dart';
import 'tambah_akun.dart';

class DaftarAkun extends StatefulWidget {
  @override
  _DaftarAkunState createState() => _DaftarAkunState();
}

class _DaftarAkunState extends State<DaftarAkun> {
  late Future<List<dynamic>> futureAkun;

  @override
  void initState() {
    super.initState();
    futureAkun = ApiService().fetchAkun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: futureAkun,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No akun found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final akun = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.greenAccent[400],
                    foregroundColor: Colors.white,
                    child: Icon(Icons.person), // Temporary icon
                  ),
                  title: Text(akun['nama_user']),
                  subtitle: Text(akun['email']),
                  trailing: Text(akun['posisi']), // Assuming 'posisi' field
                  onTap: () {
                    _showEditDeleteDialog(akun);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[400],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahAkun()),
          ).then((_) => _refreshAkunList());
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Akun',
      ),
    );
  }

  Future<void> _refreshAkunList() async {
    setState(() {
      futureAkun = ApiService().fetchAkun();
    });
  }

  void _showEditDeleteDialog(Map<String, dynamic> akun) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilihan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit"),
                onTap: () {
                  Navigator.pop(context);
                  _editAkun(akun);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Hapus"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAkun(akun);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editAkun(Map<String, dynamic> akun) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAkun(akun: akun)),
    ).then((result) {
      if (result != null && result) {
        // Refresh list jika edit berhasil
        _refreshAkunList();
      }
    });
  }

  void _deleteAkun(Map<String, dynamic> akun) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin menghapus akun ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService().deleteAkun(
                      akun['id']); // Ganti 'id' dengan field yang sesuai
                  _refreshAkunList();
                  Navigator.of(context).pop(); // Tutup dialog
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete akun')),
                  );
                }
              },
              child: Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
