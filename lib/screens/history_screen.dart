import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // No se usa directamente aquí, pero útil.
import 'package:intl/intl.dart';
// Asegúrate de que estas importaciones son correctas
import 'custom_bottom_nav.dart';
import 'package:project_sayit/models/icon_mapper_model.dart';
import 'package:project_sayit/auth/database_service.dart';

// Colores
const Color primaryColor = Color(0xFFF08C69);
const Color backgroundColor = Color(0xFFF5F5F5);

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ Importante: El StreamBuilder necesita que el usuario esté autenticado.
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildCustomAppBar(context),

      body: currentUser == null
          ? const Center(
              child: Text(
                "Inicia sesión para ver tu historial.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          // 🔥 StreamBuilder para leer historial REAL desde Firebase
          : StreamBuilder<QuerySnapshot>(
              stream: DatabaseService().getUserHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Manejo de errores de Firestore (ej. si la autenticación falló)
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar datos: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay historial todavía",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }

                final historyDocs = snapshot.data!.docs;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Historial',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Aquí encontrarás una lista de las consultas realizadas.',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 20),

                        // 🔥 Mapeamos los registros REALES
                        ...historyDocs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          final timestamp = data['timestamp'] as Timestamp?;
                          final dateTime =
                              timestamp?.toDate() ?? DateTime.now();

                          final dateFormatted = DateFormat(
                            'dd/MM/yyyy',
                          ).format(dateTime);

                          final timeFormatted = DateFormat(
                            'hh:mm a',
                          ).format(dateTime);

                          // ⚠️ Obtener el identificador del icono
                          final iconId = data['iconPath'] ?? 'default';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _HistoryCard(
                              docId: doc.id,
                              title: data['signName'] ?? 'Sin nombre',
                              date: dateFormatted,
                              time: timeFormatted,
                              iconId: iconId, // Pasamos el ID del icono
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  // AppBar personalizado
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () {
          // Navegar a la pantalla anterior o al Home
          Navigator.pop(context);
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
    );
  }
}

// --------------------------------------------------
//     TU TARJETA (_HistoryCard) + Firestore Delete
// --------------------------------------------------
class _HistoryCard extends StatelessWidget {
  final String docId;
  final String title;
  final String date;
  final String time;
  final String iconId; // ⚠️ Nuevo: ID para mapear el icono

  const _HistoryCard({
    required this.docId,
    required this.title,
    required this.date,
    required this.time,
    required this.iconId, // ⚠️ Nuevo: Requerido
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(docId),
      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),

      // 🔥 Ahora sí elimina de Firestore
      onDismissed: (direction) async {
        try {
          // Llama a la función de eliminación segura
          await DatabaseService().deleteDetection(docId);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Registro eliminado')));
        } catch (e) {
          // Mostrar un error si la eliminación falla (ej. si el usuario se desconectó)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
        }
      },

      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                // 🔥 Usamos el ID para obtener el icono
                child: Icon(
                  getIconForSign(iconId), // Usa iconId en lugar de title
                  color: primaryColor,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(width: 15),

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
}
