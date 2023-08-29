import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Home.dart';
import '../Pedido/Pedido.dart';
import '../Ventas/Ventas.dart';
import 'DetallesInsumo.dart';

class Insumo extends StatefulWidget {
  @override
  _InsumoState createState() => _InsumoState();
}

class _InsumoState extends State<Insumo> {
  List<dynamic> insumosData = [];

  @override
  void initState() {
    super.initState();
    fetchInsumosData();
  }

  Future<void> fetchInsumosData() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/insumos'));

    if (response.statusCode == 200) {
      setState(() {
        insumosData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load insumos data');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20), // Agregando espacio vertical
                child: Title(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: const Text(
                    'Insumos',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black), // Tamaño de fuente y color actualizados
                  ),
                ),
              ),
            ),
            for (var insumo in insumosData)
              Card(
                child: ListTile(
                  title:
                      Text('ID: ${insumo['id']} - Nombre: ${insumo['nombre']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Cantidad Disponible: ${insumo['cantidad_disponible']}'),
                      Text('Unidad de Medida: ${insumo['unidad_medida']}'),
                      Text('Precio Unitario: ${insumo['precio_unitario']}'),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallesInsumo(insumo['id']),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
