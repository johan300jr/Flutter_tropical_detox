// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'DetallePedidoScreen.dart';

class Pedido extends StatefulWidget {
  const Pedido({super.key});

  @override
  State<Pedido> createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
  List<dynamic> pedidos = [];
  bool isCancelled = false;
  String cancelReason = '';

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

  Future<void> _cancelarPedido(int pedidoId) async {
    TextEditingController motivoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancelar Pedido'),
          content: TextField(
            controller: motivoController,
            decoration: InputDecoration(labelText: 'Motivo de cancelación'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () async {
                String motivo = motivoController.text;
                Navigator.of(context).pop();

                final response = await http.put(
                  Uri.parse(
                      'http://127.0.0.1:8000/api/pedidos/$pedidoId/estadoo'),
                  body: json.encode({'motivo_cancelacion': motivo}),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  // Actualizar la vista después de cambiar el estado
                  fetchPedidos();
                } else {
                  print('Error al cancelar el pedido');
                }
              },
            ),
          ],
        );
      },
    );
  }

// Función para mostrar el motivo de cancelación en una alerta
  void _mostrarMotivoCancelacion(BuildContext context, String motivo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Motivo de Cancelación'),
          content: Text(motivo),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _verDetallePedido(int pedidoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallePedidoScreen(pedidoId),
      ),
    );
  }

  void _verEnMapa(String direccion) async {
    final Uri url = Uri.parse('comgooglemaps://maps.app.goo.gl/?q=$direccion');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final Uri webUrl = Uri.parse('http://maps.google.com/?q=$direccion');
      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl);
      } else {
        print('No se pudo abrir el mapa');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pedidos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Title(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: const Text(
                    'PEDIDOS',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            for (var pedido in pedidos)
              if (pedido['Estado'] != 'Finalizado')
                if (pedido['Estado'] != 'Cancelado')
                  if (pedido['Direcion'] != null)
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
                                Expanded(child: Container()),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (pedido['Estado'] == 'Terminados') {
                                        _cambiarEstadoPedido(
                                            pedido['id'], 'Finalizado');
                                      } else if (pedido['Estado'] ==
                                          'En_proceso') {
                                        _cambiarEstadoPedido(
                                            pedido['id'], 'Terminados');
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (states) {
                                          if (pedido['Estado'] ==
                                              'Terminados') {
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
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                        ),
                                      ),
                                    ),
                                    child: Text(pedido['Estado']),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _verEnMapa(pedido['Direcion']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                        ),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.location_on, // Icono de mapa
                                          color: Color.fromARGB(255, 255, 0,
                                              0), // Color del icono
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _cancelarPedido(pedido['id']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0),
                                        ),
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.cancel, // Icono de cancelar
                                          color: Color.fromARGB(255, 247, 0,
                                              0), // Color del icono
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Espacio entre el icono y el texto
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            for (var pedido in pedidos)
              if (pedido['Estado'] != 'Finalizado')
                if (pedido['Estado'] == 'Cancelado')
                  if (pedido['Direcion'] != null)
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
                                'Total: ${pedido['Total']} \nFecha: ${pedido['Fecha']} \nDirección: ${pedido['Direcion']} \nDirección: ${pedido['motivoCancelacion']}',
                              ),
                            ),
                            Row(
                              // Botón para ver motivoCancelacion
                              children: [
                                Expanded(child: Container()),
                                IconButton(
                                  onPressed: () {
                                    // Mostrar el motivo de cancelación en una alerta
                                    _mostrarMotivoCancelacion(
                                        context, pedido['motivoCancelacion']);
                                  },
                                  icon: const Icon(
                                    Icons
                                        .cancel, // Cambia 'Icons.cancel' al icono que prefieras
                                    color: Colors.red,
                                  ),
                                ),
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
