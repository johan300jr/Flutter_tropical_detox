import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
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

  void _verDetallePedido(int pedidoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedidoScreen(pedidoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Pedidos"),
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
                GestureDetector(
                  onTap: () {
                    _verDetallePedido(pedido['id']);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(pedido['users']['name']),
                          subtitle: Text(
                            'Total: ${pedido['Total']} \nFecha: ${pedido['Fecha']} \nDirección: ${pedido['Direcion']} ',
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                                  Container(), // Espacio vacío que ocupa el espacio izquierdo
                            ),
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
                                    } else if (pedido['Estado'] ==
                                        'En_proceso') {
                                      return Colors.blue;
                                    }
                                    return Colors.blue;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        3.0), // Establece el radio a 3
                                  ),
                                ),
                              ),
                              child: Text(pedido['Estado']),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) =>
                            //             DetallePedidoScreen(pedido['id']),
                            //       ),
                            //     );
                            //   },
                            //   icon: const Icon(Icons.add),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: Pedido()));
