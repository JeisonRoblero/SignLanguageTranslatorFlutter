import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_language_translator/screens/home.dart';

class InitialConfig extends StatefulWidget {
  const InitialConfig({super.key});

  @override
  State<InitialConfig> createState() => _InitialConfigState();
}

class _InitialConfigState extends State<InitialConfig> {
  bool useInternalPython = false;
  bool _isLoading = false;
  String? _pythonPath;
  bool _isConfigured = false;
  bool _pythonAutodetected = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences storage = await SharedPreferences.getInstance();

      setState(() {
        useInternalPython = storage.getBool("useInternalPython") ?? false;
        _pythonPath = storage.getString("pythonPath");
        _isConfigured = storage.getBool("isConfigured") ?? false;
        _pythonAutodetected = storage.getBool("pythonAutodetected") ?? false;

        if (!_isConfigured) {
          _autoFindPython();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface.withOpacity(0.6),
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.6),
        title: const Text(
          "Configuración Inicial",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: _isConfigured
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back),
              )
            : null,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: !_pythonAutodetected && !useInternalPython
                        ? colorScheme.error.withOpacity(0.5)
                        : colorScheme.primary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                child: IntrinsicWidth(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: 
                        !useInternalPython ? Text(
                          !_pythonAutodetected
                              ? "El interprete de Python no ha sido detectado automáticamente"
                              : "El interprete de Python ha sido detectado automáticamente",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: !_pythonAutodetected
                                  ? colorScheme.onError
                                  : colorScheme.onPrimary),
                        ) : Text(
                          "Actualmente usa python interno",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: !_pythonAutodetected
                                  ? colorScheme.onError
                                  : colorScheme.onPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      !_pythonAutodetected && !useInternalPython
                          ? Icon(
                              Icons.error,
                              color: colorScheme.onError,
                            )
                          : const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: colorScheme.primaryContainer.withOpacity(0.7),
              ),
              child: Column(
                children: [
                  Text(
                    "Sign Language Translator necesita python para funcionar, porfavor selecciona el origen de Python.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      IntrinsicWidth(
                        child: Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              value: useInternalPython,
                              onChanged: (bool? value) {
                                setState(() {
                                  useInternalPython = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            const Flexible(
                              child: Text(
                                "Usar python interno (Python en un entorno virtual)",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IntrinsicWidth(
                        child: Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              value: !useInternalPython,
                              onChanged: (bool? value) {
                                setState(() {
                                  useInternalPython = !value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            const Flexible(
                              child: Text(
                                "Usar python externo (Python instalado en el dispositivo)",
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!useInternalPython)
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "La ubicación de python podría verse de esta manera:",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurfaceVariant),
                            ),
                            Text(
                              "\"C:/Users/{NombreUser}/AppData/Local/Programs/Python/{PythonVersion}/python.exe\"",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _autoFindPython();
                                  },
                                  icon: const Icon(Icons.auto_awesome),
                                  tooltip: "Autodetectar Python",
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectFile();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: colorScheme.surface,
                                          border: Border.all(width: 1.0),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          _pythonPath ??
                                              "Click para seleccionar el interprete de python",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  colorScheme.onPrimaryContainer),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: !useInternalPython && _pythonPath == null
                            ? null
                            : () {
                                _savePythonPath(
                                    !useInternalPython
                                        ? _pythonPath!
                                        : "${Directory.current.path}/assets/python/venv/Scripts/python.exe",
                                    useInternalPython);
                              },
                        child: !_isLoading
                            ? const IntrinsicWidth(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        "Aceptar",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.check_circle,
                                      size: 20,
                                    )
                                  ],
                                ),
                              )
                            : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _autoFindPython() async {
    // Obtiene el nombre del usuario actual del sistema
    final username = Platform.environment['USERNAME'] ?? 'defaultUser';

    // Ruta base donde se encuentran las versiones de Python
    final basePath = 'C:/Users/$username/AppData/Local/Programs/Python/';

    // Verifica si el directorio base existe
    final baseDir = Directory(basePath);
    if (!await baseDir.exists()) {
      print('El directorio base $basePath no existe.');
      return;
    }

    // Lista todos los subdirectorios en el directorio base
    final versions = await baseDir.list().where((entity) {
      // Filtra solo directorios
      return entity is Directory;
    }).toList();

    // Verifica si se encontraron versiones de Python
    if (versions.isEmpty) {
      print('No se encontraron versiones de Python en $basePath.');
      return;
    }

    // Ordena los directorios por nombre en orden descendente
    versions.sort((a, b) => b.path.compareTo(a.path));

    // Obtiene el directorio de la versión más reciente
    final latestVersionDir = versions.first;

    // Construye el path al ejecutable python.exe
    final pythonExecutablePath = '${latestVersionDir.path}/python.exe';
    final pythonExecutable = File(pythonExecutablePath);

    // Verifica si el ejecutable python.exe existe
    if (await pythonExecutable.exists()) {
      print('Última versión de Python encontrada: $pythonExecutablePath');
      setState(() {
        _pythonPath = pythonExecutablePath;
        _pythonAutodetected = true;
      });

      SharedPreferences storage = await SharedPreferences.getInstance();
      storage.setString("pythonPath", _pythonPath!);
      storage.setBool("pythonAutodetected", true);
    } else {
      print(
          'No se encontró el ejecutable python.exe en ${latestVersionDir.path}');
    }
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe'],
    );

    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setBool("pythonAutodetected", false);
    setState(() {
      _pythonAutodetected = false;
    });

    if (result != null) {
      setState(() {
        _pythonPath = File(result.files.single.path!).toString();
      });
    } else {
      setState(() {
        _pythonPath = null;
      });
    }
  }

  void _savePythonPath(String pythonPath, bool useInternalPython) async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences storage = await SharedPreferences.getInstance();
      storage.setString("pythonPath", pythonPath);
      storage.setBool("useInternalPython", useInternalPython);

      if (!useInternalPython) {
        // Verifica si el archivo existe antes de intentar ejecutarlo
        if (await File("assets/python/library_install_checker.py").exists()) {
          print('El archivo existe: assets/python/library_install_checker.py');
          try {
            // Ejecuta el script usando Process.run y captura la salida
            final process = await Process.run(
                pythonPath, ["assets/python/library_install_checker.py"]);
            print('Output: ${process.stdout}');
            if (process.stderr.isNotEmpty) {
              print('Error: ${process.stderr}');
            }

            storage.setBool("isConfigured", true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );

            return;
          } catch (e) {
            print('Error al ejecutar el script: $e');
          }
        } else {
          print('El archivo no existe: assets/python/library_install_checker.py');
        }
      }

      storage.setBool("isConfigured", true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      print('Error guardando el path: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }
}
