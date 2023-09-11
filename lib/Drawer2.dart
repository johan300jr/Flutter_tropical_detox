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
                    "Juan",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                  // Text(
                  //   "Admin@gmail.com",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 16,
                  //   ),
                  // ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                "Inicio",
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              leading: const Icon(
                Icons.home,
                color: Colors.white,
                size: 35, // Tamaño de icono personalizado
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          context: context, accessToken: 'accessToken')),
                );
              },
            ),

            ListTile(
              title: const Text(
                "Insumos",
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              leading: const Icon(
                Icons.inventory,
                color: Colors.white,
                size: 35, // Tamaño de icono personalizado
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Insumo()),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Pedidos",
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
                  color: Color.fromARGB(255, 2, 0, 0),
                ),
              ),
              leading: const Icon(
                Icons.assignment,
                color: Colors.white,
                size: 35, // Tamaño de icono personalizado
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Pedido()),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Ventas",
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
                  color: Color.fromARGB(255, 10, 0, 0),
                ),
              ),
              leading: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 35, // Tamaño de icono personalizado
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Ventas()),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 20, // Tamaño de fuente personalizado
                  color: Color.fromARGB(255, 19, 0, 0),
                ),
              ),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 35, // Tamaño de icono personalizado
              ),
              onTap: () {
                // Lógica para cerrar sesión aquí
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
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
