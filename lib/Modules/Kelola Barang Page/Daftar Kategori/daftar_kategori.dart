import 'package:flutter/material.dart';
import '../../../Services/api_services.dart';

class DaftarKategori extends StatefulWidget {
  const DaftarKategori({super.key});

  @override
  _DaftarKategoriState createState() => _DaftarKategoriState();
}

class _DaftarKategoriState extends State<DaftarKategori> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _kategoriList;
  final TextEditingController _namaController = TextEditingController();
  int? _editId;

  @override
  void initState() {
    super.initState();
    _kategoriList = apiService.fetchKategori();
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _tambahKategori() async {
    try {
      await apiService.createKategori({
        'nama_kategori': _namaController.text,
      });
      setState(() {
        _kategoriList = apiService.fetchKategori();
      });
      Navigator.pop(context);
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add category')),
      );
    }
  }

  void _editKategori() async {
    try {
      await apiService.updateKategori(
        _editId!,
        {'nama_kategori': _namaController.text},
      );
      setState(() {
        _kategoriList = apiService.fetchKategori();
      });
      Navigator.pop(context);
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update category')),
      );
    }
  }

  void _showTambahKategoriDialog() {
    _namaController.clear();
    _editId = null;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Kategori'),
          content: TextField(
            controller: _namaController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _tambahKategori,
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _showEditKategoriDialog(int id, String namaKategori) {
    _namaController.text = namaKategori;
    _editId = id;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Kategori'),
          content: TextField(
            controller: _namaController,
            decoration: InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _editKategori,
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _kategoriList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _kategoriList = apiService.fetchKategori();
                });
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final kategori = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(kategori['nama_kategori']),
                        subtitle: Text('ID: ${kategori['id_kategori']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditKategoriDialog(
                                  kategori['id_kategori'],
                                  kategori['nama_kategori'],
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Hapus Kategori'),
                                    content: Text(
                                        'Apakah yakin ingin menghapus kategori?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await apiService.deleteKategori(
                                              kategori['id_kategori']);
                                          setState(() {
                                            _kategoriList =
                                                apiService.fetchKategori();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        height: 1,
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahKategoriDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
