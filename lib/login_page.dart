import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.green[200],
        scaffoldBackgroundColor: Colors.green[50],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/nose'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['accessToken'];

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      final error = jsonDecode(response.body)['message'];
      _showErrorDialog(context, error);
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  _header() {
    return Column(
      children: [
        Image.asset(
          'assets/logo2.png',
          width: 220,
          height: 220,
        ),
        Text(
          "Tropical Detox",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Ingresa tus datos para ingresar"),
      ],
    );
  }

  _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.green[100],
            filled: true,
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.green[100],
            filled: true,
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: login,
          child: Container(
            height: 30,
            child: Center(
              child: Text(
                "Acceder",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            shape: StadiumBorder(),
          ),
        ),
      ],
    );
  }

  _forgotPassword() {
    return TextButton(
      onPressed: () {
        // Navegar a la pantalla de restablecimiento de contraseña
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResetPasswordPage()),
        );
      },
      child: Text("¿Olvidaste tu contraseña?"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(),
              _inputField(),
              _forgotPassword(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  final String accessToken;
  final BuildContext context;

  UserProfileScreen(this.accessToken, this.context);

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/logout'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      final error = jsonDecode(response.body)['message'];
      _showErrorDialog(context, error);
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Evitar que se pueda volver atrás
      child: Scaffold(
        appBar: AppBar(title: Text('User Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logged in successfully!'),
              SizedBox(height: 16),
              Text('Access Token: $accessToken'),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  Future<void> sendPasswordResetEmail(String email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/password/email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Correo electrónico de restablecimiento de contraseña enviado');
    } else {
      final error = jsonDecode(response.body)['message'];
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restablecer Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                sendPasswordResetEmail(emailController.text);
              },
              child: Text('Enviar Correo de Restablecimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
