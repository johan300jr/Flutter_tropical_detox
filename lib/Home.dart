import 'package:flutter/material.dart';
import 'Insumo/Insumo.dart';
import 'Pedido/Pedido.dart';
import 'Ventas/Ventas.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatelessWidget {
  final BuildContext context;
  final String accessToken;

  const HomePage({
    required this.context,
    required this.accessToken,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tropical Detox"),
        actions: [
          // Iconos en la AppBar como antes
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // Aquí puedes agregar los elementos del menú lateral
            ListTile(
              title: const Text("Inicio"),
              leading: const Icon(Icons.home),
              onTap: () {
                // Aquí puedes realizar alguna acción relacionada con la opción "Inicio"
                // Por ejemplo, simplemente cerrar el menú lateral
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Pedido"),
              leading: const Icon(Icons.assignment),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pedido()),
                );
              },
            ),
            ListTile(
              title: const Text("Insumo"),
              leading: const Icon(Icons.inventory),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Insumo()),
                );
              },
            ),

            ListTile(
              title: const Text("Ventas"),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Ventas()),
                );
              },
            ),

            ListTile(
              title: const Text("Cerrar Sesión"),
              leading: const Icon(Icons.attach_money),
              onTap: () {
                logout(
                    accessToken, context); // Pasa el accessToken y el context
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Imagen de fondo como marca de agua

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _OptionCard(
                        imageAsset: 'assets/pedidos.png',
                        text: 'Pedidos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Pedido()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _OptionCard(
                        imageAsset: 'assets/insumo.jpeg',
                        text: 'Insumos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Insumo()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _OptionCard(
                        imageAsset: 'assets/ventas.jpeg',
                        text: 'Ventas',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Ventas()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png', // Ruta de la imagen de marca de agua
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String imageAsset;
  final String text;
  final VoidCallback onTap;

  const _OptionCard({
    required this.imageAsset,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.asset(
              imageAsset,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
          ],
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
