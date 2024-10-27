import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final String repositoryUrl =
      'https://github.com/C-Chanona/IA-Speech-and-Tools.git';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.cyan,
          actions: [
            // PopupMenuButton para mostrar el menú desplegable
            PopupMenuButton<int>(
              color: Colors.white,
              icon: const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/foto.jpg'), // Imagen de perfil
              ),
              offset: const Offset(-0, 50), // Despliega hacia la izquierda
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[],
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la Universidad
                Image.asset(
                    'assets/logo_up.png', // Asegúrate de tener este archivo en tu carpeta assets
                    height: 100),

                const SizedBox(height: 20),

                // Información de la carrera, materia, grupo, etc.
                const Text(
                  'Ingeniería en Software',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Programacion para Móviles',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '9-B',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Carlos Eduardo Chanona Aquino',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '221233',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                // Enlace al repositorio
                ElevatedButton(
                  onPressed: () async {
                    if (await canLaunch(repositoryUrl)) {
                      await launch(repositoryUrl);
                    } else {
                      throw 'No se pudo abrir el enlace $repositoryUrl';
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  // child: const Text('Repositorio Github'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/octocat.png', width: 50, height: 50),
                      const SizedBox(width: 10),
                      const Text('Visitar Github',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
