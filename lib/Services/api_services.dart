import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.1.8:8000/api";

  // Fetch list of barang
  Future<List<dynamic>> fetchBarang() async {
    final response = await http.get(Uri.parse('$baseUrl/barang'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load barang');
    }
  }

  // Fetch a single barang by id
  Future<dynamic> fetchBarangById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/barang/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load barang');
    }
  }

  // Create a new barang
  Future<dynamic> createBarang(Map<String, dynamic> barang) async {
    final response = await http.post(
      Uri.parse('$baseUrl/barang'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(barang),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create barang');
    }
  }

  // Update an existing barang
  Future<dynamic> updateBarang(int id, Map<String, dynamic> barang) async {
    final response = await http.put(
      Uri.parse('$baseUrl/barang/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(barang),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update barang');
    }
  }

  // Delete a barang
  Future<void> deleteBarang(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/barang/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete barang');
    }
  }

  Future<void> updateStokBarang(int id, int stok) async {
    final response = await http.put(
      Uri.parse('$baseUrl/barang/$id/stock'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'stok': stok,
      }),
    );

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to update stok barang');
    }
  }

  // Fetch list of kategori
  Future<List<dynamic>> fetchKategori() async {
    final response = await http.get(Uri.parse('$baseUrl/kategori'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kategori');
    }
  }

  // Fetch a single kategori by id
  Future<dynamic> fetchKategoriById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/kategori/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load kategori');
    }
  }

  // Create a new kategori
  Future<dynamic> createKategori(Map<String, dynamic> kategori) async {
    final response = await http.post(
      Uri.parse('$baseUrl/kategori'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kategori),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create kategori');
    }
  }

  // Update an existing kategori
  Future<dynamic> updateKategori(int id, Map<String, dynamic> kategori) async {
    final response = await http.put(
      Uri.parse('$baseUrl/kategori/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(kategori),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update kategori');
    }
  }

  // Delete a kategori
  Future<void> deleteKategori(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/kategori/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete kategori');
    }
  }

  // Fetch list of daily transactions
  Future<List<dynamic>> fetchDailyTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/daily-transactions'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load daily transactions');
    }
  }

// Fetch list of monthly transactions
  Future<List<dynamic>> fetchMonthlyTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/monthly-transactions'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load monthly transactions');
    }
  }

  // Create a new daily transaction
  Future<dynamic> createDailyTransaction(
      Map<String, dynamic> transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/daily-transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create daily transaction');
    }
  }

  // Create a new monthly transaction
  Future<dynamic> createMonthlyTransaction(
      Map<String, dynamic> transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/monthly-transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create monthly transaction');
    }
  }
}
