import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


class HeartRateCameraScreen extends StatefulWidget {
  final Function(int bpm) onResult;

  const HeartRateCameraScreen({super.key, required this.onResult});

  @override
  State<HeartRateCameraScreen> createState() => _HeartRateCameraScreenState();
}

class _HeartRateCameraScreenState extends State<HeartRateCameraScreen> {
  CameraController? _controller;
  bool _isMeasuring = false;
  int _currentBPM = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();

    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (mounted) {
      setState(() {});
      _startMeasuring();
    }
  }

  Future<void> _startMeasuring() async {
    try {
      await _controller!.setFlashMode(FlashMode.torch);
    } catch (e) {
      print("Torch error: $e");
      return;
    }

    setState(() => _isMeasuring = true);

    List<double> redIntensities = [];
    final stopwatch = Stopwatch()..start();

    try {
      await _controller?.startImageStream((CameraImage image) async {
        if (!mounted || !_isMeasuring) return;

        try {
          final red = _calculateRedIntensity(image);
          redIntensities.add(red);

          // Optional: Live BPM update every 1 second
          if (redIntensities.length % 20 == 0) {
            final live = _estimateLiveBPM(redIntensities);
            setState(() {
              _currentBPM = live;
            });
          }

          // Stop after 10 seconds
          if (stopwatch.elapsed.inSeconds >= 10) {
            await _controller?.stopImageStream();
            _isMeasuring = false;
            _processIntensityData(redIntensities);
          }
        } catch (e) {
          print('Frame processing error: $e');
        }
      });
    } catch (e) {
      print("Camera stream error: $e");
    }
  }

  double _calculateRedIntensity(CameraImage image) {
    final bytes = image.planes[0].bytes;
    double sum = 0;
    for (int i = 0; i < bytes.length; i += 100) {
      sum += bytes[i];
    }
    return sum / (bytes.length / 100);
  }

  int _estimateLiveBPM(List<double> data) {
    if (data.length < 20) return 0;
    final recent = data.sublist(data.length - 20);

    int peaks = 0;
    for (int i = 1; i < recent.length - 1; i++) {
      if (recent[i] > recent[i - 1] && recent[i] > recent[i + 1]) {
        peaks++;
      }
    }
    return peaks * 6; // Estimating per 10 seconds
  }

  void _processIntensityData(List<double> rawData) async {
    // Smooth using moving average (window size 5)
    List<double> smoothed = [];
    for (int i = 2; i < rawData.length - 2; i++) {
      double avg = (rawData[i - 2] +
              rawData[i - 1] +
              rawData[i] +
              rawData[i + 1] +
              rawData[i + 2]) /
          5;
      smoothed.add(avg);
    }

    // Count peaks
    int beats = 0;
    for (int i = 1; i < smoothed.length - 1; i++) {
      if (smoothed[i] > smoothed[i - 1] && smoothed[i] > smoothed[i + 1]) {
        beats++;
      }
    }

    final bpm = beats * 6;

    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      print("Torch off error: $e");
    }

    if (mounted) {
      widget.onResult(bpm);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.setFlashMode(FlashMode.off);
    }
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_controller!),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.purpleAccent, width: 4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _isMeasuring ? '$_currentBPM BPM' : '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Measuring...\nCover camera lens with your finger',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
