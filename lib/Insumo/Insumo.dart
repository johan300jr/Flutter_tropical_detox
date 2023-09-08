import 'package:flutter/material.dart';
import 'package:flutter_application_1/Appbar.dart';
import 'package:flutter_application_1/Appbar2.dart';
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
  late TextEditingController nombreController;
  late TextEditingController cantidadController;
  late TextEditingController precioUnitarioController;
  late bool activo;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
    cantidadController = TextEditingController();
    precioUnitarioController = TextEditingController();
    activo = true;
    fetchInsumosData();
  }

  Future<void> fetchInsumosData() async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/api/insumos'), // Reemplaza con tu URL de API
    );

    if (response.statusCode == 200) {
      setState(() {
        insumosData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load insumos data');
    }
  }

  void navigateToCreateInsumoForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateInsumoForm(
          onInsumoCreated: () {
            // Actualizar la lista de insumos después de crear uno nuevo
            fetchInsumosData();
          },
        ),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBar2(title: ""),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra todo verticalmente
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centra el título horizontalmente
                children: <Widget>[
                  Text(
                    "INSUMOS",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Mueve la imagen a la derecha
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      navigateToCreateInsumoForm();
                    },
                    child: Image.asset(
                      'assets/mas.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          for (var insumo in insumosData)
            Card(
              child: ListTile(
                title: Text('Nombre: ${insumo['nombre']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cantidad Disponible: ${insumo['cantidad_disponible']}'),
                    Text('Unidad de Medida: ${insumo['unidad_medida']}'),
                    Text('Precio Unitario: ${insumo['precio_unitario']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Abre la página de edición cuando tocas el ícono de lápiz
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditInsumoForm(
                              insumoData: insumo,
                              onInsumoUpdated: () {
                                // Actualizar la lista de insumos después de la edición
                                fetchInsumosData();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Abre la página de detalles cuando tocas la tarjeta
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesInsumo(insumo['id']),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    ),
  );
}
}


class CreateInsumoForm extends StatefulWidget {
  final Function() onInsumoCreated;

  CreateInsumoForm({required this.onInsumoCreated});

  @override
  _CreateInsumoFormState createState() => _CreateInsumoFormState();
}

class _CreateInsumoFormState extends State<CreateInsumoForm> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController precioUnitarioController = TextEditingController();
  bool activo = true;
  final String unidadMedida = 'Bolsa'; // Valor por defecto 'Bolsa'

  Future<void> createInsumo() async {
    final response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/api/crear'), // Reemplaza con tu URL de API
      body: {
        'nombre': nombreController.text,
        'cantidad_disponible': cantidadController.text,
        'unidad_medida': unidadMedida, // Establecer directamente 'Bolsa'
        'precio_unitario': precioUnitarioController.text,
        'activo': '1', // Cambiado a '1'
      },
    );

    if (response.statusCode == 201) {
      widget.onInsumoCreated(); // Llama a la función onInsumoCreated
      Navigator.pop(context); // Regresar a la pantalla anterior
    } else {
      throw Exception('Failed to create insumo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Crear Insumo"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/eeditar.png', // Reemplaza con la ruta de tu imagen
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              _textInputField(
                controller: nombreController,
                labelText: 'Nombre',
                icon: Icons.article,
              ),
              _textInputField(
                controller: cantidadController,
                labelText: 'Cantidad Disponible',
                keyboardType: TextInputType.number,
                icon: Icons.local_offer,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Unidad de Medida',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                child: Text(unidadMedida),
              ),
              SizedBox(height: 30),
              _textInputField(
                controller: precioUnitarioController,
                labelText: 'Precio Unitario',
                keyboardType: TextInputType.number,
                icon: Icons.attach_money,
              ),
              ElevatedButton(
                onPressed: createInsumo,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Crear',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.green[100],
            filled: true,
            prefixIcon: icon != null ? Icon(icon) : null,
          ),
          keyboardType: keyboardType,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class EditInsumoForm extends StatefulWidget {
  final dynamic insumoData;
  final Function() onInsumoUpdated;

  EditInsumoForm({required this.insumoData, required this.onInsumoUpdated});

  @override
  _EditInsumoFormState createState() => _EditInsumoFormState();
}

class _EditInsumoFormState extends State<EditInsumoForm> {
  late TextEditingController nombreController;
  late TextEditingController cantidadController;
  late TextEditingController precioUnitarioController;
  late bool activo; // Variable para almacenar el estado activo/inactivo

  final String unidadMedida = 'Bolsa'; // Valor por defecto 'Bolsa'

  _EditInsumoFormState() {
    nombreController = TextEditingController();
    cantidadController = TextEditingController();
    precioUnitarioController = TextEditingController();
    activo = true; // Establecer el valor predeterminado como activo
  }

  @override
  void initState() {
    super.initState();
    nombreController.text = widget.insumoData['nombre'];
    cantidadController.text =
        widget.insumoData['cantidad_disponible'].toString();
    precioUnitarioController.text =
        widget.insumoData['precio_unitario'].toString();
    activo = widget.insumoData['activo'] == 1;
  }

  Future<void> updateInsumo() async {
    final response = await http.put(
      Uri.parse(
          'http://127.0.0.1:8000/api/insumos/${widget.insumoData['id']}'), // Reemplaza con tu URL de API y el ID del insumo
      body: {
        'nombre': nombreController.text,
        'cantidad_disponible': cantidadController.text,
        'unidad_medida': unidadMedida, // Establecer directamente 'Bolsa'
        'precio_unitario': precioUnitarioController.text,
        'activo': activo
            ? '1'
            : '0', // Convertir el estado activo/inactivo a '1' o '0'
      },
    );

    if (response.statusCode == 200) {
      widget.onInsumoUpdated(); // Llama a la función onInsumoUpdated
      Navigator.pop(context); // Regresar a la pantalla anterior
    } else {
      throw Exception('Failed to update insumo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Actualizar Insumo"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centra el contenido verticalmente
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen centrada arriba del formulario
              Center(
                child: Image.asset(
                  'assets/eeditar.png', // Reemplaza con la ruta de tu imagen
                  width: 150, // Ancho de la imagen
                  height: 150, // Alto de la imagen
                ),
              ),
              SizedBox(
                  height:
                      20), // Espacio entre la imagen y los campos del formulario
              _textInputField(
                controller: nombreController,
                labelText: 'Nombre',
                icon: Icons.article,
              ),
              _textInputField(
                controller: cantidadController,
                labelText: 'Cantidad Disponible',
                keyboardType: TextInputType.number,
                icon: Icons.local_offer,
              ),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Unidad de Medida',
                  prefixIcon: Icon(Icons.monitor_weight),
                ),
                child: Text(unidadMedida),
              ),
              SizedBox(height: 30),
              _textInputField(
                controller: precioUnitarioController,
                labelText: 'Precio Unitario',
                keyboardType: TextInputType.number,
                icon: Icons.attach_money,
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  Text('Activo: '),
                  Switch(
                    value: activo,
                    onChanged: (value) {
                      setState(() {
                        activo = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: updateInsumo,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Actualizar',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.green[100],
            filled: true,
            prefixIcon: icon != null ? Icon(icon) : null, // Icono personalizado
          ),
          keyboardType: keyboardType,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
