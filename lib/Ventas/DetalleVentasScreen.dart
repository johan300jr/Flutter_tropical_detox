import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Insumo/Insumo.dart';
import '../Pedido/Pedido.dart';
import '../home.dart';
import 'Ventas.dart';
// import 'Pedido.dart';

class DetalleVentasScreen extends StatefulWidget {
  final int pedidoId;

  const DetalleVentasScreen(this.pedidoId, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetalleVentasScreenState createState() => _DetalleVentasScreenState();
}

class _DetalleVentasScreenState extends State<DetalleVentasScreen> {
  Map<String, dynamic> pedidoData = {};
  Set<String> nombresVistos = {};
  @override
  void initState() {
    super.initState();
    fetchPedidoDetails();
  }

  Future<void> fetchPedidoDetails() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/pedidos/${widget.pedidoId}'));

    if (response.statusCode == 200) {
      setState(() {
        pedidoData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load pedido details');
    }
  }

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
    // Cierra el menú lateral al tocar la opción "Inicio"
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
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles del Venta con ID: ${widget.pedidoId}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Detalles del pedido:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Total : ${pedidoData['pedido']['Total']}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              'Descripcion : ${pedidoData['pedido']['Descripcion']}',
              style: const TextStyle(fontSize: 12),
            ),
            if (pedidoData.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: pedidoData['detalles_pedidos'].length,
                itemBuilder: (context, index) {
                  final pedido = pedidoData['detalles_pedidos'][index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${pedido['Nombre']}'),
                      Text('Cantidad : ${pedido['cantidad']}'),
                      Text('precio unitario: ${pedido['precio_unitario']}'),
                      // Text('Precio unitario: ${insumo['precio_unitario']}'),
                      const Divider(), // Una línea divisoria entre cada insumo
                    ],
                  );
                },
              ),
            if (pedidoData.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: pedidoData['personalizados'].length,
                itemBuilder: (context, index) {
                  final personalizados = pedidoData['personalizados'][index];
                  final nombre = personalizados['nombre'];
                  if (!nombresVistos.contains(nombre)) {
                    nombresVistos.add(nombre);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nombre: $nombre'),
                        Text('Insumos: ${personalizados['insumos']}'),
                        for (var detallePersonalizado
                            in pedidoData['personalizados']) ...[
                          if (detallePersonalizado['nombre'] == nombre)
                            Text('datos: ${detallePersonalizado['datos']}'),
                        ],
                        Text('Cantidad: ${personalizados['cantidad']}'),
                        Text('Descripción: ${personalizados['Descripción']}'),
                        Text('Subtotal: ${personalizados['Subtotal']}'),
                        const Divider(), // Una línea divisoria entre cada entrada
                      ],
                    );
                  } else {
                    return const SizedBox.shrink(); // Evita mostrar duplicados
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
