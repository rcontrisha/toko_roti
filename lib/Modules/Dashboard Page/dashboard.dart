import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package
import 'package:toko_roti/Services/api_services.dart'; // Import ApiService

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<dynamic>> _futureTransactions;
  double dailyIncome = 0;
  late String today;

  @override
  void initState() {
    super.initState();
    _futureTransactions = ApiService().fetchTransactions();
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _submitDailyReport() async {
    // Buat data yang akan dikirim
    Map<String, dynamic> reportData = {
      'transaction_date': today, // Pastikan mengirim 'transaction_date'
      'total_amount': dailyIncome,
    };

    // Cetak data yang akan dikirim untuk pengecekan
    print('Data yang dikirim: $reportData');

    try {
      // Panggil API untuk mengirim laporan harian
      var response = await ApiService().createDailyTransaction(reportData);

      // Tampilkan pesan sukses jika berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Laporan harian berhasil disubmit.'),
        ),
      );
    } catch (e) {
      // Cetak error yang terjadi untuk pengecekan
      print('Error saat submit laporan: $e');

      // Tampilkan pesan error jika gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim laporan harian: $e'),
        ),
      );
    }
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

            // Filter transaksi yang tanggalnya sesuai dengan hari ini
            List<dynamic> todayTransactions = transactions.where((transaction) {
              String transactionDate =
                  transaction['transaction_date'].split(' ')[0];
              return transactionDate == today;
            }).toList();

            // Hitung pemasukan harian
            dailyIncome = 0;
            todayTransactions.forEach((transaction) {
              // Konversi nilai total_price dari String menjadi double
              double totalPrice = double.parse(transaction['total_price']);

              // Tambahkan nilai totalPrice ke dailyIncome
              dailyIncome += totalPrice;
            });

            // Hitung jumlah transaksi unik untuk hari ini
            Set<String> uniqueTodayTransactions = todayTransactions
                .map((transaction) => transaction['transaction_id'].toString())
                .toSet();

            // Hitung total pemasukan
            double totalIncome = 0;
            transactions.forEach((transaction) {
              // Konversi nilai total_price dari String menjadi double
              double totalPrice = double.parse(transaction['total_price']);

              // Tambahkan nilai totalPrice ke totalIncome
              totalIncome += totalPrice;
            });

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _submitDailyReport,
                          child: Text('Submit Laporan Harian'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card untuk Pemasukan Harian
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Pemasukan Harian',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Rp${dailyIncome.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Card untuk Jumlah Pelanggan Harian
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Jumlah Pelanggan Harian',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${uniqueTodayTransactions.length}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Card untuk Total Pemasukan
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Pemasukan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Rp${totalIncome.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Card untuk Riwayat Transaksi
                  Padding(
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Content Card untuk Riwayat Transaksi (ListView)
                              if (todayTransactions.isNotEmpty)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: todayTransactions.length,
                                    itemBuilder: (context, index) {
                                      dynamic transaction =
                                          todayTransactions[index];
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
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'Belum ada transaksi hari ini',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
