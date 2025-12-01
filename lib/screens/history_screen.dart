import 'package:flutter/material.dart';
// Asumo que esta es la ruta a tu componente de navegación inferior
import 'custom_bottom_nav.dart';

// Definición de colores
const Color primaryColor = Color(0xFFF08C69); // Tono naranja/salmón
const Color backgroundColor = Color(0xFFF5F5F5); // Fondo gris muy claro

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Lista de datos simulados para el mockup
  final List<Map<String, String>> historyItems = const [
    {
      'title': 'Stop',
      'date': '29/10/2025',
      'time': '20:00 p.m.',
      'iconPath': 'stop', // Placeholder para el ícono de stop
    },
    {
      'title': 'Right of way at intersection',
      'date': '29/10/2025',
      'time': '20:00 p.m.',
      'iconPath': 'intersection', // Placeholder
    },
    {
      'title': 'Right of way at intersection',
      'date': '29/10/2025',
      'time': '20:00 p.m.',
      'iconPath': 'intersection', // Placeholder
    },
    // Añadir más elementos para que la lista sea desplazable
    {
      'title': 'Speed limit exceeded',
      'date': '30/10/2025',
      'time': '10:30 a.m.',
      'iconPath': 'speed',
    },
    {
      'title': 'No U-Turn zone',
      'date': '01/11/2025',
      'time': '15:45 p.m.',
      'iconPath': 'uturn',
    },
    {
      'title': 'Parking violation',
      'date': '02/11/2025',
      'time': '09:00 a.m.',
      'iconPath': 'parking',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Aplicar color de fondo
      appBar: _buildCustomAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y Subtítulo
              const Text(
                'Historial',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'Aquí encontrarás una lista de las consultas realizadas.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Lista de Elementos del Historial
              ...historyItems.map((item) {
                // Usamos un Dismissible para el efecto de deslizar para eliminar
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _HistoryCard(
                    title: item['title']!,
                    date: item['date']!,
                    time: item['time']!,
                    iconName: item['iconPath']!,
                  ),
                );
              }).toList(),

              // Espacio extra al final para el BottomNav
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // Integración de la navegación inferior personalizada
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  // Widget para el AppBar personalizado
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor, // Mismo color que el fondo
      elevation: 0, // Sin sombra
      automaticallyImplyLeading: false, // Ocultar el botón 'back' por defecto
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black, // Ícono negro como en el mockup
          size: 20,
        ),
        onPressed: () {
          // Lógica de navegación hacia atrás (solo maquetado)
          // Navigator.pop(context);
        },
      ),
      title: const Text(
        'Finished',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: true,
      // Icono de batería y señal simulados (solo en el mockup, no necesario en Dart)
      actions: const [
        // Podrías poner algún icono o espacio si fuera necesario
      ],
    );
  }
}

// Widget de Tarjeta de Historial con Deslizamiento para Eliminar
class _HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String iconName;

  const _HistoryCard({
    required this.title,
    required this.date,
    required this.time,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Dismissible para manejar la acción de deslizar
    return Dismissible(
      key: Key(title + date + time), // Clave única para el elemento
      direction:
          DismissDirection.endToStart, // Deslizar solo de derecha a izquierda
      // Fondo cuando se desliza
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.red, // Color rojo para eliminar
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        // Aquí iría la lógica de eliminación. Por ahora solo es maquetado.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Elemento "$title" eliminado (Mock)')),
        );
      },
      // Contenido de la tarjeta
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para la tarjeta
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícono lateral (simulación del diseño)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                // Simulación del borde hexagonal/rombo del ícono
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                // Usamos un ícono simple como placeholder para el SVG complejo del mockup
                child: Icon(_getIcon(iconName), color: primaryColor, size: 28),
              ),
            ),
            const SizedBox(width: 15),

            // Texto principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
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

  // Función helper para obtener un ícono basado en el nombre (solo para mockup)
  IconData _getIcon(String name) {
    switch (name) {
      case 'stop':
        return Icons.do_not_disturb_alt;
      case 'intersection':
        return Icons.turn_right;
      case 'speed':
        return Icons.speed;
      case 'uturn':
        return Icons.u_turn_left;
      case 'parking':
        return Icons.local_parking;
      default:
        return Icons.info_outline;
    }
  }
}