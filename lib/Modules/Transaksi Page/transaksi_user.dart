import 'dart:math';
import 'package:flutter/material.dart';
import 'package:toko_roti/Services/api_services.dart';

class TransaksiUser extends StatefulWidget {
  @override
  _TransaksiUserState createState() => _TransaksiUserState();
}

class _TransaksiUserState extends State<TransaksiUser> {
  final ApiService _apiService = ApiService();
  List<dynamic> products = [];
  Map<dynamic, int> cart = {};
  String searchQuery = '';
  bool isLoading = true;
  late String transactionCode; // Kode transaksi

  String generateTransactionCode() {
    DateTime now = DateTime.now();
    String date =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    String randomDigits =
        Random().nextInt(100000000).toString().padLeft(8, '0');
    return 'AW-$date$randomDigits';
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    transactionCode = generateTransactionCode();
  }

  Future<void> _fetchProducts() async {
    try {
      final fetchedProducts = await _apiService.fetchBarang();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch products: $e');
    }
  }

  double get subtotal {
    return cart.entries.fold(0,
        (sum, entry) => sum + (double.parse(entry.key['harga']) * entry.value));
  }

  void addToCart(dynamic product) {
    setState(() {
      if (cart.containsKey(product)) {
        cart[product] = cart[product]! + 1;
      } else {
        cart[product] = 1;
      }
    });
  }

  void removeFromCart(dynamic product) {
    setState(() {
      if (cart.containsKey(product) && cart[product]! > 1) {
        cart[product] = cart[product]! - 1;
      } else {
        cart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredProducts = products.where((product) {
      return product['nama_barang']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          product['id_barang'].toString() == searchQuery;
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Kode Transaksi: $transactionCode",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Cari Produk (Nama atau ID)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  if (searchQuery.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        dynamic product = filteredProducts[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(product['nama_barang']),
                            subtitle: Text('Rp${product['harga']}'),
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                addToCart(product);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Keranjang',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  cart.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Keranjang Masih Kosong',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          itemBuilder: (context, index) {
                            dynamic product = cart.keys.elementAt(index);
                            int quantity = cart[product]!;
                            double harga = double.parse(product['harga']);
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(product['nama_barang']),
                                subtitle: Text(
                                    'Rp$harga x $quantity = Rp${harga * quantity}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        removeFromCart(product);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        addToCart(product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subtotal: Rp${subtotal.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (cart.isEmpty) {
                          // Tampilkan pesan error jika keranjang kosong
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Keranjang Kosong'),
                              content: Text(
                                  'Silakan tambahkan produk ke keranjang sebelum melakukan checkout.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        final transaction = {
                          'transaction_id': transactionCode,
                          'transaction_date': DateTime.now().toIso8601String(),
                          'total_price': subtotal,
                          'produk': cart.entries
                              .map((entry) => {
                                    'id_barang': entry.key['id_barang'],
                                    'quantity': entry.value,
                                    'harga': entry.key['harga'],
                                  })
                              .toList(),
                        };

                        try {
                          final result =
                              await _apiService.createTransaction(transaction);
                          // Tampilkan dialog sukses jika transaksi berhasil disimpan
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Checkout Berhasil'),
                              content: Text(
                                  'Total yang harus dibayarkan: Rp${subtotal.toStringAsFixed(2)}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      cart.clear();
                                      transactionCode =
                                          generateTransactionCode();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          // Tampilkan dialog error jika transaksi gagal disimpan
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Checkout Gagal'),
                              content: Text(
                                  'Terjadi kesalahan saat menyimpan transaksi. Silakan coba lagi.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Text('Checkout'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
