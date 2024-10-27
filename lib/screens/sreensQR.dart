import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class QR extends StatefulWidget {
  const QR({super.key});

  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QR> {
  final MobileScannerController controller = MobileScannerController();
  String? Qrresult;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'QR',
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
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Carlos Eduardo'),
                  subtitle: Text('Chanona Aquino'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.badge),
                  title: Text('221233'),
                ),
              ),
              const PopupMenuItem<int>(
                value: 0,
                child: ListTile(
                  leading: Icon(Icons.computer),
                  title: Text('Ingeneria en Software'),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: IconButton(
                    icon: SvgPicture.asset('assets/iconsgit2.svg',
                        height: 50, width: 50),
                    iconSize: 50,
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      launch(
                          "https://github.com/C-Chanona/IA-Speech-and-Tools.git");
                    }),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              child: MobileScanner(
                controller: controller,
                onDetect: (BarcodeCapture capture) async {
                  final List<Barcode> barcodes = capture.barcodes;

                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() {
                        Qrresult = barcode.rawValue!;
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              Qrresult ?? 'Escanea un código QR',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

}
