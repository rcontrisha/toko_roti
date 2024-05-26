import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toko_roti/Services/api_services.dart';

class LaporanTransaksi extends StatefulWidget {
  @override
  _LaporanTransaksiState createState() => _LaporanTransaksiState();
}

enum TransactionType { daily, monthly }

class _LaporanTransaksiState extends State<LaporanTransaksi> {
  final ApiService _apiService = ApiService();
  List<dynamic> _dailyTransactions = [];
  List<dynamic> _monthlyTransactions = [];
  TransactionType _selectedTransactionType = TransactionType.daily;
  String _selectedMonth = 'Januari';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchDailyTransactions();
    await _fetchMonthlyTransactions();
  }

  Future<void> _fetchDailyTransactions() async {
    try {
      final data = await _apiService.fetchDailyTransactions();
      setState(() {
        _dailyTransactions = data;
      });
      print('Panjang _dailyTransactions: ${_dailyTransactions.length}');
    } catch (e) {
      print('Failed to fetch daily transactions: $e');
    }
  }

  Future<void> _fetchMonthlyTransactions() async {
    try {
      final data = await _apiService.fetchMonthlyTransactions();
      setState(() {
        _monthlyTransactions = data;
      });
    } catch (e) {
      print('Failed to fetch monthly transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<TransactionType>(
                  value: _selectedTransactionType,
                  onChanged: (TransactionType? newValue) {
                    setState(() {
                      _selectedTransactionType = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem<TransactionType>(
                      value: TransactionType.daily,
                      child: Text('Harian'),
                    ),
                    DropdownMenuItem<TransactionType>(
                      value: TransactionType.monthly,
                      child: Text('Bulanan'),
                    ),
                  ],
                ),
                if (_selectedTransactionType == TransactionType.daily) ...[
                  SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMonth = newValue!;
                      });
                    },
                    items: _getMonths()
                        .map<DropdownMenuItem<String>>((String month) {
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _selectedTransactionType == TransactionType.daily
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDailyTransactionTable(),
                          _buildDailySalesChart(),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMonthlyTransactionTable(),
                          _buildMonthlySalesChart(),
                          _buildMonthlyAverageSalesChart(),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getMonths() {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
  }

  bool _hasDailyTransactionsInSelectedMonth() {
    return _dailyTransactions.any((transaction) =>
        _selectedMonth.isEmpty ||
        _getMonthFromDate(transaction['transaction_date']) == _selectedMonth);
  }

  Widget _buildDailyTransactionTable() {
    if (!_hasDailyTransactionsInSelectedMonth()) {
      return Center(
        child: Text('Tidak Ada Data Transaksi di Bulan Ini'),
      );
    }

    return DataTable(
      columns: [
        DataColumn(label: Text('Nomor')),
        DataColumn(label: Text('Tanggal')),
        DataColumn(label: Text('Total Penjualan')),
      ],
      rows: _dailyTransactions
          .where((transaction) =>
              _selectedMonth.isEmpty ||
              _getMonthFromDate(transaction['transaction_date']) ==
                  _selectedMonth)
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => DataRow(
              cells: [
                DataCell(Text((entry.key + 1).toString())),
                DataCell(Text(entry.value['transaction_date'])),
                DataCell(Text('Rp${entry.value['total_amount']}')),
              ],
            ),
          )
          .toList(),
    );
  }

  String _getMonthFromDate(String dateString) {
    final date = DateTime.parse(dateString);
    return _getMonths()[date.month - 1];
  }

  Widget _buildMonthlyTransactionTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Bulan')),
        DataColumn(label: Text('Total Penjualan')),
        DataColumn(label: Text('Rata-rata Penjualan')),
      ],
      rows: _monthlyTransactions
          .asMap()
          .entries
          .map(
            (entry) => DataRow(
              cells: [
                DataCell(Text(entry.value['transaction_month'])),
                DataCell(Text('Rp${entry.value['total_amount']}')),
                DataCell(Text('Rp${entry.value['average_amount']}')),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildDailySalesChart() {
    if (!_hasDailyTransactionsInSelectedMonth()) {
      return Center(
        child: Text('Tidak Ada Data Transaksi di Bulan Ini'),
      );
    }

    List filteredTransactions = _dailyTransactions
        .where((transaction) =>
            _getMonthFromDate(transaction['transaction_date']) ==
            _selectedMonth)
        .toList();

    List<double> salesData = filteredTransactions.map<double>((transaction) {
      try {
        return double.parse(transaction['total_amount'].toString());
      } catch (e) {
        return 0.0; // Atau nilai default lainnya jika tidak valid
      }
    }).toList();

    List<FlSpot> spots = List.generate(
      salesData.length,
      (index) => FlSpot(index.toDouble(), salesData[index]),
    );

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 300,
      width: 400,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: false), // Menghapus angka-angka di sumbu y
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int day = value.toInt() + 1;
                  if (day > filteredTransactions.length) {
                    return Container();
                  } else {
                    String date =
                        filteredTransactions[day - 1]['transaction_date'];
                    return Text(
                      DateFormat('dd').format(DateTime.parse(date)),
                      style: TextStyle(fontSize: 10),
                    );
                  }
                },

                interval:
                    1, // Mengatur interval untuk memastikan tanggal tidak berulang
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(show: false),
            ),
          ],
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: 0,
          maxY: salesData.reduce(
                  (value, element) => value > element ? value : element) *
              1.1,
        ),
      ),
    );
  }

  Widget _buildMonthlySalesChart() {
    List<double> monthlySalesData =
        _monthlyTransactions.map<double>((transaction) {
      try {
        return double.parse(transaction['total_amount'].toString());
      } catch (e) {
        return 0.0; // Nilai default jika tidak valid
      }
    }).toList();

    List<String> months = _monthlyTransactions.map<String>((transaction) {
      try {
        return transaction['transaction_month'].toString();
      } catch (e) {
        return '';
      }
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Grafik Total Penjualan per Bulan',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          height: 300,
          width: 400,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            months[index],
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return Text('');
                    },
                    interval: 1,
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              barGroups: List.generate(
                monthlySalesData.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: monthlySalesData[index],
                      color: Colors.blue,
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyAverageSalesChart() {
    List<double> monthlyAverageSalesData =
        _monthlyTransactions.map<double>((transaction) {
      try {
        return double.parse(transaction['average_amount'].toString());
      } catch (e) {
        return 0.0; // Nilai default jika tidak valid
      }
    }).toList();

    // Daftar bulan yang sesuai dengan data yang Anda gunakan dalam tabel
    List<String> months = _monthlyTransactions.map<String>((transaction) {
      try {
        return transaction['transaction_month'].toString();
      } catch (e) {
        return '';
      }
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            'Grafik Rata-rata Penjualan Bulanan',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
          height: 300,
          width: 400,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < months.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            months[index],
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return Text('');
                    },
                    interval: 1,
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              barGroups: List.generate(
                monthlyAverageSalesData.length,
                (index) => BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: monthlyAverageSalesData[index],
                      color: Colors.blue,
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
