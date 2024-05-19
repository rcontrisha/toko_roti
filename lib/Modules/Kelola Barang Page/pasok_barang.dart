import 'package:flutter/material.dart';
import '../../../Services/api_services.dart';

class PasokBarang extends StatefulWidget {
  const PasokBarang({Key? key}) : super(key: key);

  @override
  _PasokBarangState createState() => _PasokBarangState();
}

class _PasokBarangState extends State<PasokBarang> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _barangList;

  @override
  void initState() {
    super.initState();
    _barangList = apiService.fetchBarang();
  }

  void _updateStok(int id, int newStok) async {
    try {
      await apiService.updateStokBarang(id, newStok);
      setState(() {
        _barangList = apiService.fetchBarang();
      });
    } catch (error) {
      print('Error updating stok: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update stok')),
      );
    }
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> barang) {
    final TextEditingController _stokController =
        TextEditingController(text: barang['stok'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Stok ${barang['nama_barang']}'),
        content: TextField(
          controller: _stokController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Stok',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newStok = int.tryParse(_stokController.text);
              if (newStok != null) {
                _updateStok(barang['id_barang'], newStok);
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _barangList,
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
                  _barangList = apiService.fetchBarang();
                });
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final barang = snapshot.data![index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(barang['nama_barang']),
                        subtitle: Text('Stok: ${barang['stok']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showEditDialog(context, barang),
                        ),
                      ),
                      Divider(
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
    );
  }
}
