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
import 'package:project_sayit/app_styles.dart'; // <--- ESTA LÍNEA
import 'dart:ui' as ui;
// Constante de estilo simple (reemplaza con tu archivo app_styles.dart si lo tienes)
//const TextStyle kBodyTextStyle = TextStyle(fontSize: 16);

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
    "https://tensorflow-signs-model-latest.onrender.com/v1/models/signs-model:predict",
  );
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  // La variable de simulación (_simulatedIndexJson) ha sido eliminada.
  // Ahora cargaremos el index.json real en la función de envío.

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

  // 📸 Lógica para tomar foto
  Future<void> _takePicture() async {
    // 1. Validaciones iniciales
    if (!_isCameraInitialized ||
        _controller == null ||
        _controller!.value.isTakingPicture ||
        _isPredicting) {
      return;
    }

    // 2. ⚠️ NUEVA VERIFICACIÓN CRÍTICA: Asegurarse de que la vista previa está activa.
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

      // 4. Tomar la foto (aquí es donde fallaba)
      final XFile file = await _controller!.takePicture();
      final tempImage = File(file.path);

      // 5. Actualizar la imagen y procesar
      setState(() {
        _image = tempImage;
      });

      // 6. Llamar a la función de envío al servidor
      final result = await _enviarImagenAlServidorJson(tempImage);

      // 7. Finalizar carga y mostrar resultado
      setState(() {
        _predictionResult = result;
        _isPredicting = false;
      });
    } on CameraException catch (e) {
      // Capturamos específicamente el error de la cámara
      setState(() {
        _isPredicting = false;
        _predictionResult = 'Error de Cámara al tomar la foto: ${e.code}';
      });
    } catch (e) {
      // Capturamos cualquier otro error
      setState(() {
        _isPredicting = false;
        _predictionResult = 'Error desconocido: $e';
      });
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
  /// Convierte la imagen a 200x200 en escala de grises y luego a una lista de píxeles normalizados 3D.
  Future<List<List<List<double>>>> _processImage(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception("No se pudo decodificar la imagen.");
    }

    // Redimensionar y convertir a escala de grises (200x200x1)
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 200,
      height: 200,
    );
    img.Image grayscaleImage = img.grayscale(resizedImage);

    // Estructurar como tensor 3D: [Height, Width, Channel] -> [200, 200, 1]
    List<List<List<double>>> tensor3D = List.generate(
      grayscaleImage.height, // 200
      (y) => List.generate(
        grayscaleImage.width, // 200
        (x) {
          final pixel = grayscaleImage.getPixelSafe(x, y);
          final grayValue = pixel.r;
          final normalizedValue = grayValue / 255.0;

          // Retorna una lista con un solo elemento para el canal: [1]
          return [normalizedValue];
        },
      ),
    );

    return tensor3D; // Retorna la estructura [200, 200, 1]
  }

  // ⚡ FUNCIÓN: Enviar JSON al servidor con carga de index.json real (LÓGICA CORREGIDA)
  Future<String> _enviarImagenAlServidorJson(File imageFile) async {
    try {
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

        // 1. Obtener el índice con mayor probabilidad (Lógica robusta)
        final maxProb = pred.reduce((a, b) => a > b ? a : b);
        final maxIndex = pred.indexOf(maxProb);

        // 2. Cargar el archivo index.json real
        final value = await rootBundle.loadString('assets/json/index.json');
        var datos = json.decode(value) as Map<String, dynamic>;

        // 3. Mapear el índice al nombre de la clase
        var classResultEntry = datos[maxIndex.toString()] as List<dynamic>?;

        String classResultPrediction;

        if (classResultEntry != null && classResultEntry.length > 1) {
          classResultPrediction = classResultEntry[1].toString();
        } else {
          classResultPrediction = "Clase no encontrada para ID: $maxIndex";
        }

        return "Predicción Exitosa:\nID del Modelo: $maxIndex\nProbabilidad Máxima: ${maxProb.toStringAsFixed(4)}\nResultado: $classResultPrediction";
      } else {
        return "Error del Servidor: ${res.statusCode}. Cuerpo: ${res.body}";
      }
    } catch (e) {
      return "Error al conectar o procesar la API: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Deshabilitar botones si está prediciendo
    final bool buttonsDisabled = _isPredicting || !_isCameraInitialized;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detector de Señales'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 📸 Vista de la Cámara o Imagen Seleccionada
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.cover)
                  : _isCameraInitialized && _controller != null
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: CameraPreview(_controller!),
                    )
                  : const Center(child: Text('Cargando cámara...')),
            ),
            const SizedBox(height: 20),

            // 🔘 Botones de Acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: buttonsDisabled
                      ? null
                      : _takePicture, // Deshabilitar si predice
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),

                // Botón Voltear Cámara (Centro)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: InkWell(
                        onTap: buttonsDisabled
                            ? null
                            : _switchCamera, // Deshabilitar si predice
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cameraswitch, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Voltear',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: buttonsDisabled
                      ? null
                      : _pickImage, // Deshabilitar si predice
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galería'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 📰 Área de Resultado de la Predicción
            Text(
              'Resultado de la Predicción:',
              style: kBodyTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: _isPredicting
                    ? Colors.yellow.shade100
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: _isPredicting
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    ) // Indicador de carga visible
                  : Text(
                      _predictionResult,
                      style: kBodyTextStyle.copyWith(
                        color: Colors.blue.shade800,
                      ),
                    ),
            ),
          ],
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
