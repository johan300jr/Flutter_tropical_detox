import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Home.dart';
import '../Pedido/Pedido.dart';
import '../Ventas/Ventas.dart';
import 'Insumo.dart';
import 'package:flutter_application_1/Appbar2.dart';

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
      appBar: const CustomAppBar2(title: "Detalle de Insumo"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Detalle de Insumo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre: ${insumoData['nombre']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Cantidad Disponible: ${insumoData['cantidad_disponible']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Unidad de Medida: ${insumoData['unidad_medida']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Precio Unitario: \$${insumoData['precio_unitario']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Fecha de Creación: ${insumoData['created_at']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Última Actualización: ${insumoData['updated_at']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
