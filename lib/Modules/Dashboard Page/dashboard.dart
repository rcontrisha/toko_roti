import 'package:flutter/material.dart';
import 'package:toko_roti/Services/api_services.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<dynamic>> _futureTransactions;

  @override
  void initState() {
    super.initState();
    _futureTransactions = ApiService().fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _futureTransactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Data transaksi berhasil dimuat
            List<dynamic> transactions = snapshot.data!;

            // Hitung pemasukan harian
            double dailyIncome = 0;
            transactions.forEach((transaction) {
              // Konversi nilai total_price dari String menjadi double
              double totalPrice = double.parse(transaction['total_price']);

              // Tambahkan nilai totalPrice ke dailyIncome
              dailyIncome += totalPrice;
            });

            // Hitung jumlah transaksi unik
            Set<String> uniqueTransactions = transactions
                .map((transaction) => transaction['transaction_id'].toString())
                .toSet();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card untuk Pemasukan Harian
                        Container(
                          width: 300,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pemasukan Harian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rp${dailyIncome.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Card untuk Jumlah Pelanggan Harian
                        Container(
                          width: 300,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Jumlah Pelanggan Harian',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${uniqueTransactions.length}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Card untuk Total Pemasukan
                        Container(
                          width: 300,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Pemasukan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Rp${dailyIncome.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Column 2
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 400, // Atur tinggi card lebih besar
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title Card untuk Riwayat Transaksi
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Riwayat Transaksi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Content Card untuk Riwayat Transaksi (ListView)
                              Expanded(
                                child: ListView.builder(
                                  itemCount: transactions.length,
                                  itemBuilder: (context, index) {
                                    dynamic transaction = transactions[index];
                                    return ListTile(
                                      title: Text(
                                          'Transaction ID: ${transaction['transaction_id']}'),
                                      subtitle: Text(
                                          'Transaction Date: ${transaction['transaction_date']}'),
                                      trailing: Text(
                                          'Total Price: Rp${transaction['total_price']}'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
