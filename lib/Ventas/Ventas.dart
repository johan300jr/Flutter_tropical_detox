import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Drawer2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Pedido/DetallePedidoScreen.dart';
import 'DetalleVentasScreen.dart';

class Ventas extends StatefulWidget {
  const Ventas({Key? key});

  @override
  State<Ventas> createState() => _VentasState();
}

class _VentasState extends State<Ventas> {
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
      final List<dynamic> allPedidos = json.decode(response.body);
      final List<dynamic> finalizadosPedidos = allPedidos
          .where((pedido) => pedido['Estado'] == 'Finalizado')
          .toList();

      setState(() {
        pedidos = finalizadosPedidos;
      });
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Ventas"),
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
                  vertical: 20,
                ),
                child: Title(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  child: const Text(
                    'Ventas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            for (var pedido in pedidos)
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleVentasScreen(pedido['id']),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(pedido['users']['name']),
                        subtitle: Text(
                          'Total: ${pedido['Total']} \nFecha: ${pedido['Fecha']} \nDirección: ${pedido['Direcion']} ',
                        ),
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

void main() => runApp(const MaterialApp(home: Ventas()));
