import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_language_translator/screens/initial_config.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isCollecting = false;
  bool _isCreatingDataSet = false;
  bool _isTraining = false;
  bool _isTranslating = false;
  double _process = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withOpacity(0.6),
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.6),
        title: const Text(
          "Traductor de Lengua de Señas",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InitialConfig(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isCollecting)
                Column(
                  children: [
                    Text(
                      "Recolectando imagenes de entrenamiento...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/imgs/training.gif",
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${(_process * 100).toInt()}% completado, recolectando...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        child: LinearProgressIndicator(value: _process)),
                  ],
                ),
              if (_isCreatingDataSet)
                Column(
                  children: [
                    Text(
                      "Creando set de datos de las imagenes recolectadas...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/imgs/training.gif",
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${(_process * 100).toInt()}% completado, convirtiendo...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        child: LinearProgressIndicator(value: _process)),
                  ],
                ),
              if (_isTraining)
                Column(
                  children: [
                    Text(
                      "Entrenando modelo de Inteligencia artificial...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/imgs/training.gif",
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${(_process * 100).toInt()}% completado, entrenando...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(
                        width: 300,
                        child: LinearProgressIndicator(value: _process)),
                  ],
                ),
              if (_isTranslating)
                Column(
                  children: [
                    Text(
                      "Traduciendo de lenguaje de señas a voz y texto...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/imgs/translate.gif",
                      width: 300,
                      height: 300,
                    ),
                  ],
                ),
              if (!_isCollecting &&
                  !_isCreatingDataSet &&
                  !_isTraining &&
                  !_isTranslating)
                Column(
                  children: [
                    Text(
                      "Bienvenido al mejor traductor de señas :)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      "assets/imgs/welcome.webp",
                      width: 300,
                      height: 300,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isTraining || _isTranslating
                    ? null
                    : () async {
                        await _executePython(["assets/python/collect_imgs.py"],
                            mode: "collecting");
                        await _executePython(
                            ["assets/python/create_dataset.py"],
                            mode: "creatingDataSet");
                        await _executePython(
                            ["assets/python/train_classifier.py"],
                            mode: "training");
                      },
                child: const IntrinsicWidth(
                  child: Row(
                    children: [
                      Icon(Icons.fitness_center),
                      SizedBox(width: 10),
                      Flexible(child: Text("Entrenar IA")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isTraining || _isTranslating
                    ? null
                    : () {
                        _executePython(
                            ["assets/python/inference_classifier.py"],
                            mode: "translating");
                      },
                child: const IntrinsicWidth(
                  child: Row(
                    children: [
                      Icon(Icons.translate),
                      SizedBox(width: 10),
                      Flexible(child: Text("Traducir lengua de señas")),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _executePython(List<String> arguments, {String? mode}) async {
    if (mode == "collecting") {
      setState(() {
        _isCollecting = true;
        _process = 0.0;
      });
    }

    if (mode == "creatingDataSet") {
      setState(() {
        _isCreatingDataSet = true;
        _process = 0.54;
      });
    }

    if (mode == "training") {
      setState(() {
        _isTraining = true;
        _process = 0.77;
      });
    }

    if (mode == "translating") {
      setState(() {
        _isTranslating = true;
      });
    }

    // const executionPath =
    //     "C:/Users/Jeison/AppData/Local/Programs/Python/Python312/python.exe";

    SharedPreferences storage = await SharedPreferences.getInstance();
    String executionPath = storage.getString("pythonPath")!;

    // Verifica si el archivo existe antes de intentar ejecutarlo
    if (await File(arguments[0]).exists()) {
      print('El archivo existe: $arguments[0]');
      try {
        // Ejecuta el script usando Process.run y captura la salida
        _incrementProcess(mode);
        final process = await Process.run(executionPath, arguments);
        print('Output: ${process.stdout}');
        if (process.stderr.isNotEmpty) {
          print('Error: ${process.stderr}');
        }
      } catch (e) {
        print('Error al ejecutar el script: $e');
      }
    } else {
      print('El archivo no existe: $arguments[0]');
    }

    if (mode == "collecting") {
      setState(() {
        _isCollecting = false;
      });
    }

    if (mode == "creatingDataSet") {
      setState(() {
        _isCreatingDataSet = false;
      });
    }

    if (mode == "training") {
      setState(() {
        _isTraining = false;
      });
    }

    if (mode == "translating") {
      setState(() {
        _isTranslating = false;
      });
    }
  }

  void _incrementProcess(String? mode) async {
    if (mode != null) {
      if (mode == "collecting") {
        for (int i = 0; i < 53; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _process = i / 100;
          });
        }
      }

      if (mode == "creatingDataSet") {
        for (int i = 54; i < 76; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _process = i / 100;
          });
        }
      }

      if (mode == "training") {
        for (int i = 77; i < 100; i++) {
          await Future.delayed(const Duration(milliseconds: 100));
          setState(() {
            _process = i / 100;
          });
        }
      }
    }
  }
}
