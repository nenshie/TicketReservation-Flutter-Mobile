import 'dart:io';

import 'package:cinema_reservations_front/services/ReservationService.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;
  bool _isProcessing = false;

  final ReservationService _reservationService = ReservationService();


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    }
    _qrController?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green,
              borderRadius: 10,
              borderLength: 40,
              borderWidth: 12,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      final code = scanData.code?.trim();
      if (code != null && code.isNotEmpty && !_isProcessing) {
        _qrController?.pauseCamera();
        setState(() {
          _isProcessing = true;
        });

        try {

          bool success = await _reservationService.confirmReservationFromQr(code);

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reservation confirmed successfully!')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to confirm reservation.')));
            _qrController?.resumeCamera();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
          _qrController?.resumeCamera();
        } finally {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}
