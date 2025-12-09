import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  // Widget para crear un título de sección con un ícono
  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para crear el cuerpo del texto de la política
  Widget _buildPolicyBody(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }

  // Widget para crear listas o puntos clave dentro de una sección
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.4),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFF9A826); // Un color azul para destacar

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad y Privacidad'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- TÍTULO PRINCIPAL ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'POLÍTICA DE PRIVACIDAD',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),

            // --- INTRODUCCIÓN ---
            _buildPolicyBody(
              "La presente Política de Privacidad establece los términos en que Snap Sign usa y protege la información proporcionada por sus usuarios al momento de utilizar su aplicación móvil. Nuestra compañía está comprometida con la seguridad de los datos de sus usuarios. Cuando solicitamos información personal, lo hacemos asegurando que solo se empleará de acuerdo con los términos de este documento. Sin embargo, esta Política de Privacidad puede cambiar o ser actualizada, por lo que le recomendamos revisar continuamente esta página.",
            ),

            // --- INFORMACIÓN QUE ES RECOGIDA ---
            _buildSectionTitle(
              'Información que es Recogida',
              Icons.info_outline,
              primaryColor,
            ),
            _buildPolicyBody(
              'Nuestra aplicación móvil podrá recoger información personal:',
            ),
            _buildBulletPoint(
              'Nombre y Contacto: Nombre, dirección de correo electrónico y contraseña de acceso (almacenada de forma cifrada).',
            ),
            _buildBulletPoint(
              'Historial de Predicciones (IA): Guarda un pequeño historial con el nombre de la predicción, el porcentaje de precisión y la fecha.',
            ),
            _buildBulletPoint(
              'Nota Importante sobre Imágenes: En ningún caso se almacenan fotografías ni imágenes proporcionadas por el usuario. Estas se procesan únicamente para obtener el resultado y posteriormente se descartan.',
            ),
            _buildPolicyBody(
              'Así mismo, cuando sea necesario, podrá ser requerida información específica para procesar algún pedido o realizar una entrega o facturación.',
            ),

            // --- USO DE LA INFORMACIÓN RECOGIDA ---
            _buildSectionTitle(
              'Uso de la Información Recogida',
              Icons.settings,
              primaryColor,
            ),
            _buildPolicyBody(
              'Empleamos la información con el fin de proporcionar el mejor servicio posible, particularmente para:',
            ),
            _buildBulletPoint(
              'Mantener un registro de usuarios y mejorar nuestros servicios.',
            ),
            _buildBulletPoint(
              'Enviar correos electrónicos periódicamente con ofertas especiales, nuevos productos e información publicitaria relevante (estos correos pueden ser cancelados en cualquier momento).',
            ),
            _buildPolicyBody(
              'Snap Sign está altamente comprometido para cumplir con el compromiso de mantener su información segura.',
            ),

            // --- ENLACES A TERCEROS ---
            _buildSectionTitle('Enlaces a Terceros', Icons.link, primaryColor),
            _buildPolicyBody(
              'Este sitio web pudiera contener enlaces a otros sitios que pudieran ser de su interés. Una vez que usted dé clic y abandone nuestra página, ya no tenemos control. Por lo tanto, no somos responsables de la privacidad ni de la protección de sus datos en esos otros sitios. Es recomendable que consulte sus propias políticas de privacidad.',
            ),

            // --- CONTROL DE SU INFORMACIÓN PERSONAL ---
            _buildSectionTitle(
              'Control de su Información Personal',
              Icons.verified_user,
              primaryColor,
            ),
            _buildPolicyBody(
              'En cualquier momento usted puede restringir la recopilación o el uso de su información. Puede cancelar las suscripciones a correos o notificaciones cuando lo desee.',
            ),
            _buildPolicyBody(
              'Prohibición de Venta de Datos: Esta compañía no venderá, cederá ni distribuirá la información personal que es recopilada sin su consentimiento, salvo que sea requerido por un juez con una orden judicial.',
            ),

            // --- PROCEDIMIENTO PARA ELIMINAR SU CUENTA ---
            _buildSectionTitle(
              'Eliminación de Cuenta y Datos Personales',
              Icons.delete_forever,
              Colors.red,
            ),
            _buildPolicyBody(
              'El usuario podrá solicitar la eliminación total de su cuenta y de todos los datos asociados enviando un correo a nuestro servicio de soporte:',
            ),
            _buildBulletPoint('Correo: snapsign.live@gmail.com'),
            _buildPolicyBody(
              'Tras recibir la solicitud y confirmar su identidad, se eliminarán de manera permanente su nombre, correo electrónico, contraseña cifrada y el historial de predicciones. Esta acción es irreversible.',
            ),

            // --- MODIFICACIÓN DE LA POLÍTICA ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Snap Sign Se reserva el derecho de cambiar los términos de la presente Política de Privacidad en cualquier momento.',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
