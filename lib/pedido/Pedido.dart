import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../home.dart';
import '../Insumo/Insumo.dart';
import '../Ventas/Ventas.dart';
import 'DetallePedidoScreen.dart';

class Pedido extends StatefulWidget {
  const Pedido({super.key});

  @override
  State<Pedido> createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
  List<dynamic> pedidos = [];

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/pedidos'));

    if (response.statusCode == 200) {
      setState(() {
        pedidos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  Future<void> _cambiarEstadoPedido(int pedidoId, String nuevoEstado) async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/pedidos/$pedidoId/estado'),
      body: json.encode({'Estadoo': nuevoEstado}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Actualiza la lista de pedidos después de cambiar el estado
      fetchPedidos();
    } else {
      // Manejar el error si es necesario
      print('Error al cambiar el estado del pedido');
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
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20), // Agregando espacio vertical
                child: Title(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: const Text(
                    'Pedidos',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .black), // Tamaño de fuente y color actualizados
                  ),
                ),
              ),
            ),
            for (var pedido in pedidos)
              if (pedido['Estado'] != 'Finalizado')
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(pedido['users']['name']),
                        subtitle: Text(
                          'Total: ${pedido['Total']} \nFecha: ${pedido['Fecha']} \nDirecion: ${pedido['Direcion']} ',
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (pedido['Estado'] == 'Terminados') {
                                _cambiarEstadoPedido(
                                    pedido['id'], 'Finalizado');
                              } else if (pedido['Estado'] == 'En_proceso') {
                                _cambiarEstadoPedido(
                                    pedido['id'], 'Terminados');
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (states) {
                                  if (pedido['Estado'] == 'Terminados') {
                                    return const Color.fromARGB(
                                        255, 55, 204, 55);
                                  } else if (pedido['Estado'] == 'En_proceso') {
                                    return Colors.blue;
                                  }
                                  return Colors.blue;
                                },
                              ),
                            ),
                            child: Text(pedido['Estado']),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetallePedidoScreen(pedido['id']),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: Pedido()));
