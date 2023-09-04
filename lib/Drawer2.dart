import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home.dart';
import 'package:flutter_application_1/Insumo/Insumo.dart';
import 'package:flutter_application_1/Pedido/Pedido.dart';
import 'package:flutter_application_1/Ventas/Ventas.dart';
import 'login_page.dart';

class MyDrawer2 extends StatelessWidget {
  final BuildContext context;
  final String accessToken;

  const MyDrawer2({
    required this.context,
    required this.accessToken,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green, // Verde como color principal
              Colors.orange, // Naranja como color principal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/logo.png'), // Imagen desde la ruta 'assets/pedidos.png'
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nombre de Usuario",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Correo Electrónico",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Inicio"),
              leading: const Icon(Icons.home, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(context: context, accessToken: 'accessToken',)),
                );
              },
            ),
            ListTile(
              title: const Text("Pedido"),
              leading: const Icon(Icons.assignment, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Pedido()),
                );
              },
            ),
            ListTile(
              title: const Text("Insumo"),
              leading: const Icon(Icons.inventory, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Insumo()),
                );
              },
            ),
            ListTile(
              title: const Text("Ventas"),
              leading: const Icon(Icons.attach_money, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Ventas()),
                );
              },
            ),
            // ListTile(
            //   title: const Text("Cerrar Sesión"),
            //   leading: const Icon(Icons.exit_to_app, color: Colors.white),
            //   onTap: () {
            //     logout(
            //         accessToken, context); // Pasa el accessToken y el context
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
