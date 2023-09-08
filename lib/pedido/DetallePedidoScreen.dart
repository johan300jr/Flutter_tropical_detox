import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/Appbar2.dart';


import '../Insumo/Insumo.dart';
import '../Ventas/Ventas.dart';
import '../home.dart';
import 'Pedido.dart';

class DetallePedidoScreen extends StatefulWidget {
  final int pedidoId;

  const DetallePedidoScreen(this.pedidoId, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetallePedidoScreenState createState() => _DetallePedidoScreenState();
}

class _DetallePedidoScreenState extends State<DetallePedidoScreen> {
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
      appBar: const CustomAppBar2(title: "Detalle de pedido"),
     
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalles del Pedido con ID: ${widget.pedidoId}',
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
                            Text(': ${detallePersonalizado['datos']}'),
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
