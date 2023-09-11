import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Home.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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
        MaterialPageRoute(
          builder: (context) => HomePage(
            context: context,
            accessToken: accessToken,
          ),
        ),
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
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Correo",
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
              hintText: "Contraseña",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.green[100],
              filled: true,
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            autofocus: false, // Evita que aparezca el teclado automáticamente
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: login,
            child: Container(
              height: 50, // Aumenta la altura del botón a 50
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
      ),
    );
  }

  _forgotPassword() {
    return TextButton(
      onPressed: () {
        // Navegar a la pantalla de restablecimiento de contraseña
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SolicitarCorreoPage()),
        );
      },
      child: Text("¿Olvidaste tu contraseña?"),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(),
                _inputField(),
                _forgotPassword(),
                // Agrega más widgets si es necesario
              ],
            ),
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

class SolicitarCorreoPage extends StatefulWidget {
  @override
  _SolicitarCorreoPageState createState() => _SolicitarCorreoPageState();
}

class _SolicitarCorreoPageState extends State<SolicitarCorreoPage> {
  TextEditingController emailController = TextEditingController();

  Future<void> solicitarCodigo() async {
    String email = emailController.text;

    // Verificar si el campo de correo electrónico está vacío
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa tu correo electrónico.'),
        ),
      );
      return; // Salir de la función si el campo está vacío
    }

    // Verificar el formato del correo electrónico usando una expresión regular
    bool isEmailValid =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);

    if (!isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('El formato del correo electrónico es inválido.'),
        ),
      );
      return; // Salir de la función si el formato del correo es inválido
    }

    // Resto del código para enviar la solicitud HTTP y manejar las respuestas
    var response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/recuperar-contrasena'),
      body: {'email': email},
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Navega a la página para verificar el código si la solicitud fue exitosa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              VerificarCodigoPage(email: email), // Pasa el correo aquí
        ),
      );
    } else if (response.statusCode == 404) {
      // Correo no encontrado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Correo no encontrado o inválido.'),
        ),
      );
    } else {
      // Otra respuesta de error genérica
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo enviar el código de recuperación.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(216, 27, 26, 26), // Fondo verde
        elevation: 0, // Sin sombra
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
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
              // Espacio flexible para empujar hacia arriba
              Text(
                  "Ingresa tu correo electrónico para recuperar tu contraseña."),

              SizedBox(height: 40),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: solicitarCodigo,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 32, 33, 34), // Color de fondo personalizado
                  ),
                  child: Text(
                    'Solicitar Código',
                    style: TextStyle(
                      fontSize: 18, // Ajusta el tamaño de fuente aquí
                    ),
                    textAlign:
                        TextAlign.center, // Centra el texto horizontalmente
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VerificarCodigoPage extends StatefulWidget {
  final String email; // Variable para almacenar el correo electrónico

  VerificarCodigoPage(
      {required this.email}); // Constructor que recibe el correo

  @override
  _VerificarCodigoPageState createState() => _VerificarCodigoPageState();
}

class _VerificarCodigoPageState extends State<VerificarCodigoPage> {
  TextEditingController codigoController = TextEditingController();

  Future<void> verificarCodigo() async {
    String codigo = codigoController.text;
    String email = widget.email; // Obtén el correo electrónico de widget

    // Verificar si el campo de código de recuperación está vacío
    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa el código de recuperación.'),
        ),
      );
      return; // Salir de la función si el campo está vacío
    }

    // Realiza una solicitud HTTP para verificar el código
    var response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/verificar-codigo'),
      body: {
        'codigo': codigo,
        'email': email
      }, // Pasa el correo electrónico en la solicitud
    );

    if (response.statusCode == 200) {
      // Navega a la página para cambiar la contraseña si el código es válido
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CambiarContrasenaPage(
              email:
                  email), // También puedes pasar el correo aquí si es necesario
        ),
      );
    } else {
      // Muestra un mensaje de error si el código es inválido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Codigo invalido'),
        ),
      );
      return;
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(216, 27, 26, 26), // Fondo verde
        elevation: 0, // Sin sombra
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
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
              Text("Ingresa el código de recuperación enviado a tu correo."),
              SizedBox(height: 40),
              TextField(
                controller: codigoController,
                decoration:
                    InputDecoration(labelText: 'Código de Recuperación'),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: verificarCodigo,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 32, 33, 34), // Color de fondo personalizado
                  ),
                  child: Text(
                    'Verificar',
                    style: TextStyle(
                      fontSize: 18, // Ajusta el tamaño de fuente aquí
                    ),
                    textAlign:
                        TextAlign.center, // Centra el texto horizontalmente
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CambiarContrasenaPage extends StatefulWidget {
  final String email;
  CambiarContrasenaPage({required this.email});

  @override
  _CambiarContrasenaPageState createState() => _CambiarContrasenaPageState();
}

class _CambiarContrasenaPageState extends State<CambiarContrasenaPage> {
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController confirmarContrasenaController = TextEditingController();

  Future<void> cambiarContrasena() async {
    String email = widget.email;
    String contrasena = contrasenaController.text;

    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/cambiarContrasena'), // Reemplaza con la URL correcta
      body: {
        'email': email,
        'password': contrasena,
        'password_confirmation': confirmarContrasenaController.text,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final message = jsonResponse['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      // Puedes navegar a otra página o realizar otras acciones según tu aplicación
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo cambiar la contraseña.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(216, 27, 26, 26), // Fondo verde
        elevation: 0, // Sin sombra
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(
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
              SizedBox(height: 40),
              // Espacio flexible para empujar hacia arriba
              Text("Crea una nueva contraseña para tu cuenta."),
              SizedBox(height: 40),
              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Nueva Contraseña'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmarContrasenaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: cambiarContrasena,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 32, 33, 34), // Color de fondo personalizado
                  ),
                  child: Text(
                    'Cambiar Contraseña',
                    style: TextStyle(
                      fontSize: 18, // Ajusta el tamaño de fuente aquí
                    ),
                    textAlign:
                        TextAlign.center, // Centra el texto horizontalmente
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
