import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class NutritionCameraCaptureScreen extends StatefulWidget {
  const NutritionCameraCaptureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<NutritionCameraCaptureScreen> createState() =>
      _NutritionCameraCaptureScreenState();
}

class _NutritionCameraCaptureScreenState
    extends State<NutritionCameraCaptureScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _controller = controller;
      _isInitialized = true;
    });
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      Navigator.of(context).pop<Uint8List>(bytes);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Capture Nutrition Photo')),
      body: _isInitialized && _controller != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: FloatingActionButton(
                      onPressed: _capture,
                      child: _isCapturing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
