import 'dart:convert';
import 'package:flutter/material.dart';
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
              scrollDirection: Axis.horizontal,
              child: _selectedTransactionType == TransactionType.daily
                  ? _buildDailyTransactionTable()
                  : _buildMonthlyTransactionTable(),
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
}
