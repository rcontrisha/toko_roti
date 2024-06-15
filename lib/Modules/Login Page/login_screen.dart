import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/Modules/Home%20Page/home_view.dart';
import 'package:toko_roti/Services/api_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool obsecureText = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.greenAccent[400],
      body: _isLoading ? _buildLoadingIndicator() : _buildLoginForm(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent[400],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/logo_roti.png',
                height: 100,
                width: 100,
              ),
              _buildUsernameField(),
              SizedBox(height: 10),
              _buildPasswordField(),
              SizedBox(height: 30),
              Container(
                height: 40,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      cursorColor: Colors.grey[600],
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.greenAccent[700]!),
        ),
        labelText: 'Username',
        hintText: 'Enter your Username',
        prefixIcon: Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: obsecureText,
      decoration: InputDecoration(
        floatingLabelStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.greenAccent[700]!),
        ),
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obsecureText = !obsecureText;
            });
          },
          icon: Icon(
            obsecureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil metode login dari ApiService untuk memverifikasi kredensial
      var user = await ApiService().login(username, password);
      var access = await ApiService().fetchAccessRightById(user["username"]);

      // Debug logging untuk memastikan data akun yang diterima
      print('User: $user');

      // Simpan nama pengguna dan hak akses di shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('nama_user', user['username']);
      prefs.setBool('can_manage_account', access['can_manage_account'] == 1);
      prefs.setBool('can_manage_items', access['can_manage_items'] == 1);
      prefs.setBool(
          'can_manage_transactions', access['can_manage_transactions'] == 1);
      prefs.setBool('can_manage_reports', access['can_manage_reports'] == 1);

      // Navigasikan ke halaman beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Tangani kesalahan login
      print('Failed to login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid username or password')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
