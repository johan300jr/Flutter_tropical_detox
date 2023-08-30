import 'package:flutter/material.dart';
import 'Insumo/Insumo.dart';
import 'Pedido/Pedido.dart';
import 'Ventas/Ventas.dart';

void main() => runApp(const MaterialApp(home: HomePage()));

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tropical Detox"),
        actions: const [
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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
                  Expanded(
                    child: _OptionCard(
                      imageAsset: 'assets/pedidos.png',
                      text: 'Pedidos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Pedido()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: _OptionCard(
                      imageAsset: 'assets/insumo.jpeg',
                      text: 'Insumos',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Insumo()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: _OptionCard(
                      imageAsset: 'assets/ventas.jpeg',
                      text: 'Ventas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Ventas()),
                        );
                      },
                    ),
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
