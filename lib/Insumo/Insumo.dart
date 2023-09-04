import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
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
      appBar: const CustomAppBar(title: "Insumos"),
      drawer: MyDrawer2(
        context: context,
        accessToken: 'accessToken',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesInsumo(insumo['id']),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(
                        'Nombre: ${insumo['nombre']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Cantidad Disponible: ${insumo['cantidad_disponible']}'),
                        Text('Unidad de Medida: ${insumo['unidad_medida']}'),
                        Text('Precio Unitario: ${insumo['precio_unitario']}'),
                      ],
                    ),
                    // trailing: Icon(Icons.add),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
