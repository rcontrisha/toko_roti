import 'package:flutter/material.dart';
import '../../../Services/api_services.dart';

class DaftarBarang extends StatefulWidget {
  @override
  _DaftarBarangState createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _barangList;
  late Future<List<dynamic>> _kategoriList;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  int? _editId;
  int? _selectedKategoriId;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    _barangList = apiService.fetchBarang();
    _kategoriList = apiService.fetchKategori();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  void _editBarang() async {
    try {
      await apiService.updateBarang(
        _editId!,
        {
          'nama_barang': _namaController.text,
          'harga': double.parse(_hargaController.text),
          'id_kategori': _selectedKategoriId,
        },
      );
      setState(() {
        _reloadData();
      });
      Navigator.pop(context);
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update barang')),
      );
    }
  }

  void _tambahBarang() async {
    try {
      await apiService.createBarang({
        'nama_barang': _namaController.text,
        'harga': double.parse(_hargaController.text),
        'stok': int.parse(_stokController.text),
        'id_kategori': _selectedKategoriId,
      });
      setState(() {
        _reloadData();
      });
      Navigator.pop(context);
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add barang')),
      );
    }
  }

  void _showEditBarangDialog(dynamic barang) {
    _namaController.text = barang['nama_barang'];
    _hargaController.text = barang['harga'].toString();
    _selectedKategoriId = barang['id_kategori'];
    _editId = barang['id_barang'];
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<dynamic>>(
          future: _kategoriList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available'));
            } else {
              return AlertDialog(
                title: Text('Edit Barang'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    TextField(
                      controller: _hargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedKategoriId = newValue;
                        });
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<int>>((dynamic kategori) {
                        return DropdownMenuItem<int>(
                          value: kategori['id_kategori'],
                          child: Text(kategori['nama_kategori']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Kategori'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: _editBarang,
                    child: Text('Update'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _showTambahBarangDialog() {
    _namaController.clear();
    _hargaController.clear();
    _stokController.clear();
    _selectedKategoriId = null;
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<dynamic>>(
          future: _kategoriList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available'));
            } else {
              return AlertDialog(
                title: Text('Tambah Barang'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama Barang'),
                    ),
                    TextField(
                      controller: _hargaController,
                      decoration: InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _stokController,
                      decoration: InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<int>(
                      value: _selectedKategoriId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedKategoriId = newValue;
                        });
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<int>>((dynamic kategori) {
                        return DropdownMenuItem<int>(
                          value: kategori['id_kategori'],
                          child: Text(kategori['nama_kategori']),
                        );
                      }).toList(),
                      decoration: InputDecoration(labelText: 'Kategori'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: _tambahBarang,
                    child: Text('Tambah'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _deleteBarang(dynamic barang) async {
    try {
      await apiService.deleteBarang(barang['id_barang']);
      setState(() {
        _reloadData();
      });
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete barang')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _reloadData();
          });
        },
        child: FutureBuilder<List<dynamic>>(
          future: _barangList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final barang = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(barang['nama_barang']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Harga: Rp${barang['harga']}'),
                            Text('Stok: ${barang['stok']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _showEditBarangDialog(barang),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Hapus Barang'),
                                    content: Text(
                                        'Apakah yakin ingin menghapus barang?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          _deleteBarang(barang);
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
                      Divider(
                        thickness: 1,
                        height: 5,
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahBarangDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
