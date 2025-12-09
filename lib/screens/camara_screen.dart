import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para rootBundle
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Paquete de preprocesamiento
import 'package:project_sayit/app_styles.dart';
import 'package:project_sayit/auth/database_service.dart';
import 'dart:ui' as ui; // Importación necesaria para ImageFilter
import 'package:project_sayit/models/signal_description.dart';
import 'package:project_sayit/screens/detail_screen.dart';
import 'package:crypto/crypto.dart';

class CamaraScreen extends StatefulWidget {
  const CamaraScreen({super.key});

  @override
  State<CamaraScreen> createState() => _CamaraScreenState();
}

class _CamaraScreenState extends State<CamaraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  File? _image;
  String _predictionResult = 'Esperando imagen...';
  bool _isPredicting = false; // nos ayuda para mejor manejo la carga/predicción

  // 1. Datos de la API para el endpoint de predicción
  final url = Uri.parse(
    "https://tensorflow-serving-snapsign-1-0.onrender.com/v1/models/snapsign_model:predict",
  );
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Lógica de inicialización de cámara
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _predictionResult = 'No se encontraron cámaras.');
        return;
      }

      // Asume la cámara trasera, o la primera si no se especifica.
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller?.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    } catch (e) {
      setState(() => _predictionResult = 'Error al inicializar la cámara: $e');
    }
  }

  // 🆕 FUNCIÓN DE MITIGACIÓN: Calcula el Hash SHA-256 de un archivo
  Future<String> _calculateFileHash(File file) async {
    try {
      // 1. Lee el archivo como bytes
      final bytes = await file.readAsBytes();

      // 2. Calcula el hash SHA-256 de los bytes
      final digest = sha256.convert(bytes);

      // 3. Devuelve el hash como una cadena hexadecimal
      print("hash de la imagen: $digest");
      return digest.toString();
    } catch (e) {
      print("Error al calcular el hash de la imagen: $e");
      // En caso de error, devolver una cadena vacía o un indicador de error.
      return '';
    }
  }

  // 📸 Lógica para tomar foto
  Future<void> _takePicture() async {
    // 1. Validaciones iniciales MÁS FUERTES
    if (!_isCameraInitialized || _controller == null || _isPredicting) {
      return;
    }

    // ⚠️ NUEVO: Asegurarse de que la cámara no está ocupada tomando una foto.
    if (_controller!.value.isTakingPicture) {
      setState(() {
        _predictionResult = 'La cámara está ocupada, espere un momento.';
      });
      return;
    }

    // ⚠️ VERIFICACIÓN CRÍTICA: Vista previa activa.
    if (!_controller!.value.isInitialized) {
      setState(() {
        _predictionResult = 'La cámara no está lista. Intente de nuevo.';
      });
      return;
    }

    try {
      // 3. Iniciar estado de carga y mensaje ANTES de tomar la foto
      setState(() {
        _isPredicting = true;
        _predictionResult = 'Enviando imagen para predicción...';
      });

      // 4. Tomar la foto (el await es CRÍTICO aquí)
      final XFile file = await _controller!.takePicture();
      final tempImage = File(file.path);

      // 5. Actualizar la imagen y procesar
      if (mounted) {
        setState(() {
          _image = tempImage;
        });
      }

      // 6. Llamar a la función de envío al servidor
      final result = await _enviarImagenAlServidorJson(tempImage);

      // 7. Finalizar carga y mostrar resultado
      if (mounted) {
        setState(() {
          _predictionResult = result;
          _isPredicting = false;
        });
      }
    } on CameraException catch (e) {
      // Capturamos específicamente el error de la cámara
      print('CameraException: ${e.code}');
      if (mounted) {
        setState(() {
          _isPredicting = false;
          _predictionResult = 'Error de Cámara al tomar la foto: ${e.code}';
        });
      }
    } catch (e) {
      // Capturamos cualquier otro error
      print('Error desconocido en _takePicture: $e');
      if (mounted) {
        setState(() {
          _isPredicting = false;
          _predictionResult = 'Error desconocido: $e';
        });
      }
    }
  }

  // 🖼️ Lógica para seleccionar de galería
  Future<void> _pickImage() async {
    if (_isPredicting) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final tempImage = File(pickedFile.path);

      setState(() {
        _image = tempImage;
        _isPredicting = true;
        _predictionResult = 'Enviando imagen para predicción...';
      });

      // Llamar a la función de envío al servidor
      final result = await _enviarImagenAlServidorJson(tempImage);

      setState(() {
        _predictionResult = result;
        _isPredicting = false;
      });
    }
  }

  // ⚙️ FUNCIÓN: Preprocesar imagen (CORRECCIÓN A 3D)
  Future<List<List<List<double>>>> _processImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception("No se pudo decodificar la imagen.");
    }

    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 270,
      height: 270,
    );

    img.Image grayscaleImage = img.grayscale(resizedImage);

    List<List<List<double>>> tensor3D = List.generate(
      grayscaleImage.height,
      (y) => List.generate(grayscaleImage.width, (x) {
        final pixel = grayscaleImage.getPixel(x, y);
        final normalizedValue = pixel.r / 255.0;
        return [normalizedValue];
      }),
    );

    return tensor3D;
  }

  // ⚡ FUNCIÓN: Enviar JSON al servidor con carga de index.json real (LÓGICA CORREGIDA)
  Future<String> _enviarImagenAlServidorJson(File imageFile) async {
    try {
      // MITIGACIÓN 1: CALCULAR EL HASH ANTES DE ENVIAR
      final imageHash = await _calculateFileHash(imageFile);
      if (imageHash.isEmpty) {
        return "Error: No se pudo generar la huella digital (hash) de la imagen.";
      }
      // ----------------------------------------------------
      final processedImage = await _processImage(imageFile);

      final predictionInstance = {
        "instances": [processedImage],
      };

      final res = await http.post(
        url,
        headers: headers,
        body: jsonEncode(predictionInstance),
      );

      if (res.statusCode == 200) {
        final jsonPrediction = jsonDecode(res.body);
        final pred = jsonPrediction['predictions'][0] as List;

        final maxProb = pred.cast<double>().reduce((a, b) => a > b ? a : b);
        final maxIndex = pred.indexOf(maxProb);

        final value = await rootBundle.loadString('assets/json/index.json');
        var datos = json.decode(value) as Map<String, dynamic>;

        var classResultEntry = datos[maxIndex.toString()] as List<dynamic>?;

        String classResultPrediction;

        if (classResultEntry != null && classResultEntry.length > 1) {
          classResultPrediction = classResultEntry[1].toString();
        } else {
          classResultPrediction = "Clase no encontrada para ID: $maxIndex";
        }

        if (classResultEntry != null) {
          final signalId = classResultEntry[0].toString();
          final signalName = classResultEntry[1].toString();
          final imageFileHash = imageHash;

          await DatabaseService().saveDetection(
            signResult: signalName,
            confidence: maxProb,
            signalId: signalId,
            iconPath: signalId,
            imageHash: imageFileHash,
          );

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignalDetailScreen(
                  signalId: classResultEntry[0].toString(),
                  signalName: classResultEntry[1].toString(),
                  imageFile: imageFile,
                ),
              ),
            );
          }
          return "Señal identificada y detalles cargados.";
        }

        return "Predicción Exitosa:\nID del Modelo: $maxIndex\nProbabilidad Máxima: ${maxProb.toStringAsFixed(4)}\nResultado: $classResultPrediction";
      } else {
        return "Error del Servidor: ${res.statusCode}. Cuerpo: ${res.body}";
      }
    } catch (e) {
      return "Error al conectar o procesar la API: $e";
    }
  }

  // 🎯 Widget para construir botones de control (Glassmorphism)
  Widget _buildMinimalControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
    required Color borderColor,
    required bool isTopControl,
  }) {
    // ⚠️ CORRECCIÓN CLAVE: Aumentar el grosor del borde a 2 o 3. Usamos 2.
    const double borderWidth = 3.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: isTopControl ? 45 : 55,
            height: isTopControl ? 45 : 55,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: borderColor.withOpacity(
                  0.8,
                ), // Aumentamos la opacidad para que el borde se vea mejor
                width: borderWidth, // 🚀 AUMENTO DEL GROSOR
              ),
            ),
            child: Icon(icon, color: iconColor, size: isTopControl ? 20 : 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ Colores coherentes con el minimalismo y el color principal
    const minimalBackgroundColor = Color(0xFFF5F5F5);
    const primaryAppColor = const Color.fromARGB(170, 255, 112, 2);
    const floatingControlColor = Colors.white;

    return Scaffold(
      backgroundColor: minimalBackgroundColor,
      body: SafeArea(
        child: Container(
          color: minimalBackgroundColor,
          child: Stack(
            children: [
              // CÁMARA O IMAGEN DE PREVIEW
              Positioned.fill(
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : (_isCameraInitialized
                          ? CameraPreview(_controller!)
                          : const Center(
                              child: CircularProgressIndicator(
                                color: primaryAppColor,
                              ),
                            )),
              ),

              // ❌ 1. BOTÓN DE SALIDA (ESQUINA SUPERIOR IZQUIERDA - Glassmorphism)
              Positioned(
                top: 10,
                left: 10,
                child: _buildMinimalControlButton(
                  icon: Icons.close,
                  onTap: () => Navigator.pop(context),
                  iconColor:
                      primaryAppColor, // 🎯 CORREGIDO: Usando primaryAppColor
                  borderColor:
                      primaryAppColor, // 🎯 CORREGIDO: Usando primaryAppColor
                  isTopControl: true,
                ),
              ),

              // 🔄 2. BOTÓN RETOMAR FOTO (ESQUINA SUPERIOR DERECHA - Glassmorphism)
              if (_image != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: _buildMinimalControlButton(
                    icon: Icons.refresh,
                    onTap: () {
                      setState(() {
                        _image = null;
                        _predictionResult = "";
                      });
                    },
                    iconColor:
                        primaryAppColor, // 🎯 CORREGIDO: Usando primaryAppColor
                    borderColor:
                        primaryAppColor, // 🎯 CORREGIDO: Usando primaryAppColor
                    isTopControl: true,
                  ),
                ),

              // Controles inferiores
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Indicador del estado de predicción (Glassmorphism aplicado)
                    if (_isPredicting)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryAppColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Analizando...",
                              style: TextStyle(
                                color: floatingControlColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 14),

                    // Fila de controles de cámara
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 🔄 BOTÓN DE CAMBIO DE CÁMARA (Glassmorphism y Borde Grueso)
                        _buildMinimalControlButton(
                          icon: Icons.cameraswitch,
                          onTap: _switchCamera,
                          iconColor: primaryAppColor,
                          borderColor: primaryAppColor,
                          isTopControl: false,
                        ),

                        // 📸 Botón de captura (Círculo Estilo iOS - Glassmorphism)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: BackdropFilter(
                            filter: ui.ImageFilter.blur(
                              sigmaX: 8.0,
                              sigmaY: 8.0,
                            ),
                            child: GestureDetector(
                              onTap: _takePicture,
                              child: Container(
                                width: 75,
                                height: 75,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                    color: primaryAppColor.withOpacity(0.8),
                                    width:
                                        7, // Mantenemos 4.0 aquí para que sea el principal
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 🖼️ BOTÓN DE GALERÍA (Glassmorphism y Borde Grueso)
                        _buildMinimalControlButton(
                          icon: Icons.photo_library,
                          onTap: _pickImage,
                          iconColor: primaryAppColor,
                          borderColor: primaryAppColor,
                          isTopControl: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) {
      debugPrint("Solo hay una cámara disponible.");
      return;
    }

    final currentCamera = _controller!.description;
    CameraDescription newCamera;

    if (currentCamera == _cameras![0]) {
      newCamera = _cameras![1];
    } else {
      newCamera = _cameras![0];
    }

    await _controller!.dispose();

    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error al cambiar la cámara: $e");
    }
  }
}
