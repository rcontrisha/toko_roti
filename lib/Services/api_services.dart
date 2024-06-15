import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://roti-api.000webhostapp.com/api";

  Future<dynamic> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Fetch list of akun
  Future<List<dynamic>> fetchAkun() async {
    final response = await http.get(Uri.parse('$baseUrl/akun'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load akun');
    }
  }

  // Fetch a single akun by id
  Future<dynamic> fetchAkunById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/akun/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load akun');
    }
  }

  // Create a new akun
  Future<dynamic> createAkun(Map<String, dynamic> akun) async {
    final response = await http.post(
      Uri.parse('$baseUrl/akun'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(akun),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create akun');
    }
  }

  // Update an existing akun
  Future<dynamic> updateAkun(int id, Map<String, dynamic> akun) async {
    final response = await http.put(
      Uri.parse('$baseUrl/akun/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(akun),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update akun');
    }
  }

  // Delete an akun
  Future<void> deleteAkun(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/akun/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete akun');
    }
  }

  // Existing functions for other services...

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

  // Fetch user access rights
  Future<List<dynamic>> fetchAccessRights() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/access-rights'))
          .timeout(Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('The connection has timed out!');
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load access rights');
      }
    } catch (e) {
      print('Error fetching access rights: $e');
      rethrow;
    }
  }

  // Fetch a single access right by id
  Future<dynamic> fetchAccessRightById(String username) async {
    final response =
        await http.get(Uri.parse('$baseUrl/access-rights/$username'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load access right');
    }
  }

  // Create a new access right
  Future<dynamic> createAccessRight(Map<String, dynamic> accessRight) async {
    final response = await http.post(
      Uri.parse('$baseUrl/access-rights'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(accessRight),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create access right');
    }
  }

  // Update access right
  Future<dynamic> updateAccessRight(
      String username, Map<String, dynamic> accessRight) async {
    try {
      final response = await http
          .put(
        Uri.parse('$baseUrl/access-rights/$username'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(accessRight),
      )
          .timeout(Duration(seconds: 60), onTimeout: () {
        throw TimeoutException('The connection has timed out!');
      });

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Failed to update access right. Status code: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to update access right');
      }
    } catch (e) {
      print('Error updating access right: $e');
      rethrow;
    }
  }

  // Delete an access right
  Future<void> deleteAccessRight(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/access-rights/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete access right');
    }
  }

  // Fetch list of transactions
  Future<List<dynamic>> fetchTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/transactions'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  // Fetch a single transaction by id
  Future<dynamic> fetchTransactionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/transactions/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  // Create a new transaction
  Future<dynamic> createTransaction(Map<String, dynamic> transaction) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create transaction');
    }
  }

  // Update an existing transaction
  Future<dynamic> updateTransaction(
      int id, Map<String, dynamic> transaction) async {
    final response = await http.put(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(transaction),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update transaction');
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/transactions/$id'));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete transaction');
    }
  }
}
