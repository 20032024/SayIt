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
import 'dart:ui' as ui;
import 'package:project_sayit/models/signal_description.dart';
import 'package:project_sayit/screens/detail_screen.dart';

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

          await DatabaseService().saveDetection(
            signResult: signalName,
            confidence: maxProb,
            signalId: signalId,
            iconPath: signalId,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
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
                              color: Colors.orange,
                            ),
                          )),
            ),

            // ❌ 1. BOTÓN DE SALIDA (ESQUINA SUPERIOR IZQUIERDA)
            Positioned(
              top: 10,
              left: 10,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black54,
                heroTag:
                    'exitButton', // Añadido para evitar errores si hay muchos FABs
                onPressed: () {
                  // Vuelve a la pantalla anterior (menú principal)
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),

            // 🔄 2. BOTÓN RETOMAR FOTO (ESQUINA SUPERIOR DERECHA)
            if (_image != null)
              Positioned(
                top: 10,
                right: 10,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black54,
                  heroTag: 'refreshButton', // Añadido para evitar errores
                  onPressed: () {
                    setState(() {
                      _image = null;
                      _predictionResult = "";
                    });
                  },
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),

            // Controles inferiores
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Indicador del estado de predicción
                  if (_isPredicting)
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Analizando...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                        ),
                        iconSize: 34,
                        onPressed: _switchCamera,
                      ),

                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        iconSize: 34,
                        onPressed: _pickImage,
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
