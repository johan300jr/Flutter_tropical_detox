import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home.dart';
import 'package:flutter_application_1/Insumo/Insumo.dart';
import 'package:flutter_application_1/Ventas/Ventas.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/pedido/Pedido.dart';

class Appbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tropical Detox"),
        actions:  [
          IconButton(
            icon:
                Icon(Icons.menu), // Puedes usar cualquier ícono de tu elección
            onPressed: () {
              // Aquí abriremos el cajón de navegación
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
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
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                // Lógica para cerrar sesión aquí
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      // El contenido de tu pantalla principal va aquí
      // Por ejemplo: body: MiPantallaPrincipal(),
    ); //scafold
  }
}

// Define las clases de pantalla (Pedido, Insumo, Ventas) si aún no están definidas.
