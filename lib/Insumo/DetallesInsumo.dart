import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Home.dart';
import '../Pedido/Pedido.dart';
import '../Ventas/Ventas.dart';
import 'Insumo.dart';

class DetallesInsumo extends StatefulWidget {
  final int insumoId;

  DetallesInsumo(this.insumoId);

  @override
  _DetallesInsumoState createState() => _DetallesInsumoState();
}

class _DetallesInsumoState extends State<DetallesInsumo> {
  Map<String, dynamic> insumoData = {};

  @override
  void initState() {
    super.initState();
    fetchInsumoData();
  }

  Future<void> fetchInsumoData() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:8000/api/insumos/${widget.insumoId}'));

    if (response.statusCode == 200) {
      setState(() {
        insumoData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load insumo data');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${insumoData['id']}'),
            Text('Nombre: ${insumoData['nombre']}'),
            Text('Cantidad Disponible: ${insumoData['cantidad_disponible']}'),
            Text('Unidad de Medida: ${insumoData['unidad_medida']}'),
            Text('Precio Unitario: ${insumoData['precio_unitario']}'),
            Text('Fecha de Creación: ${insumoData['created_at']}'),
            Text('Última Actualización: ${insumoData['updated_at']}'),
          ],
        ),
      ),
    );
  }
}
