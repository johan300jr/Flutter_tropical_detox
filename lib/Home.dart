import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
// import 'package:flutter_application_1/Menu.dart';
import 'Insumo/Insumo.dart';
import 'Pedido/Pedido.dart';
import 'Ventas/Ventas.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Insumo/Insumo.dart';
import '../Ventas/Ventas.dart';
import '../home.dart';

class HomePage extends StatelessWidget {
  final String accessToken;
  final BuildContext context;

  const HomePage({
    required this.context,
    required this.accessToken,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tropical detox"),
      drawer: MyDrawer2(
        accessToken: accessToken,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Título "Tropical Detox"
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    const SizedBox(height: 30),
                    // Resto del contenido

                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: _OptionCard(
                        text: 'Insumos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Insumo(),
                            ),
                          );
                        },
                        color: Color.fromARGB(
                            197, 209, 238, 46), // Color amarillo suave
                        imageAsset:
                            'assets/insumos1.png', // Imagen para Insumos
                      ),
                    ),
                    const SizedBox(height: 20),

                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: _OptionCard(
                        text: 'Pedidos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Pedido(),
                            ),
                          );
                        },
                        color: Color.fromARGB(
                            206, 89, 236, 60), // Color verde suave
                        imageAsset:
                            'assets/pedidos1.png', // Imagen para Pedidos
                      ),
                    ),

                    const SizedBox(height: 20),
                    FractionallySizedBox(
                      widthFactor: 0.8,
                      child: _OptionCard(
                        text: 'Ventas',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Ventas(),
                            ),
                          );
                        },
                        color: Color.fromARGB(
                            207, 245, 154, 35), // Color naranja suave
                        imageAsset: 'assets/ventas1.png', // Imagen para Ventas
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final String imageAsset;

  const _OptionCard({
    required this.text,
    required this.onTap,
    required this.color,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
          color: color,
        ),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  imageAsset,
                  width: 120,
                  height: 120,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    text.toUpperCase(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> logout(String accessToken, BuildContext context) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/logout');

  try {
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Redirige al usuario a la página de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      final error = jsonDecode(response.body)['message'];
      _showErrorDialog(context, error);
    }
  } catch (error) {
    print('Error al cerrar la sesión: $error');
  }
}

void _showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error al cerrar la sesión'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}
