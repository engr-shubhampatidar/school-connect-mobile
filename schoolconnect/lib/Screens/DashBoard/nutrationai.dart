import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nutrition_ai/nutrition_ai.dart';
import 'package:schoolconnect/Screens/DashBoard/nutrition_camera_capture_screen.dart';
import 'package:schoolconnect/services/nutrition_ai_service.dart';

const String _passioSdkKey = String.fromEnvironment(
  'PASSIO_SDK_KEY',
  defaultValue: 'cmYN8D6rzSkouDrIk53WxdYd3ylmZvymg7Awt7c3',
);

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NutritionAiScreen();
  }
}

class NutritionAiScreen extends StatefulWidget {
  const NutritionAiScreen({super.key});

  @override
  State<NutritionAiScreen> createState() => _NutritionAiScreenState();
}

class _NutritionAiScreenState extends State<NutritionAiScreen> {
  static const int _maxImageBytes = 6 * 1024 * 1024;

  final TextEditingController _sdkKeyController = TextEditingController(
    text: _passioSdkKey,
  );
  final TextEditingController _messageController = TextEditingController();
  final NutritionAiService _service = NutritionAiService();

  PassioStatus? _passioStatus;
  final List<_ChatMessage> _messages = [];
  final List<String> _debugLogs = [];
  bool _isConfiguring = false;
  bool _isInitializingAdvisor = false;
  bool _isSending = false;
  bool _isDetectingCamera = false;
  bool _advisorReady = false;
  List<PassioAdvisorFoodInfo> _detectedFoods = const [];
  PassioFoodItem? _detectedNutritionItem;
  String? _detectedPreviewString;
  String? _detectionError;
  late final _PassioDebugStatusListener _statusListener;

  @override
  void initState() {
    super.initState();
    _statusListener = _PassioDebugStatusListener(onLog: _addDebug);
    _service.setStatusListener(_statusListener);
    _logSdkEnvironment();
  }

  @override
  void dispose() {
    _service.setStatusListener(null);
    _sdkKeyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _logSdkEnvironment() async {
    _addDebug('env:platform=$defaultTargetPlatform');
    try {
      final version = await _service.getSdkVersion();
      _addDebug('env:sdkVersion=${version ?? 'unknown'}');
    } catch (error) {
      _addDebug('env:sdkVersionError=$error');
    }
  }

  Future<void> _configureAndInitAdvisor() async {
    final key = _sdkKeyController.text.trim().isEmpty
        ? _passioSdkKey
        : _sdkKeyController.text.trim();
    final keyHasOnlyAlphaNum = RegExp(r'^[A-Za-z0-9]+$').hasMatch(key);
    _addDebug(
      'configure:start keyLength=${key.length} alphaNum=$keyHasOnlyAlphaNum',
    );
    if (key.isEmpty) {
      _showSnackBar('Passio SDK key missing. Add key or use --dart-define.');
      _addDebug('configure:aborted empty key');
      return;
    }

    setState(() {
      _isConfiguring = true;
      _advisorReady = false;
    });

    try {
      final status = await _service.configureForAdvisor(key: key, debugMode: 1);
      _addDebug('configure:status $status');

      if (!mounted) return;

      setState(() {
        _passioStatus = status;
      });

      if (status.mode != PassioMode.isReadyForDetection) {
        final errorName = status.error?.name ?? 'unknown';
        final missingFiles =
            (status.missingFiles == null || status.missingFiles!.isEmpty)
            ? 'none'
            : status.missingFiles!.join(', ');
        _addDebug(
          'configure:notReady mode=${status.mode.name} error=$errorName missingFiles=$missingFiles debug=${status.debugMessage}',
        );
        final networkLost = (status.debugMessage ?? '').toLowerCase().contains(
          'network connection was lost',
        );
        _showSnackBar(
          networkLost
              ? 'Network disconnected while configuring SDK. Check internet and retry.'
              : 'SDK status: ${status.mode.name} | error: $errorName | missingFiles: $missingFiles | ${status.debugMessage ?? ''}'
                    .trim(),
        );
        return;
      }

      _addDebug('configure:readyForDetection');

      setState(() {
        _isInitializingAdvisor = true;
      });

      final initResult = await _service.initAdvisor();
      _addDebug('advisor:init result=$initResult');
      if (!mounted) return;

      switch (initResult) {
        case Success():
          setState(() {
            _advisorReady = true;
          });
          _addDebug('advisor:init success');
          _showSnackBar('Nutrition Advisor is ready.');
          break;
        case Error(message: final message):
          _addDebug('advisor:init error=$message');
          _showSnackBar('Failed to initialize advisor: $message');
          break;
      }
    } catch (error, stackTrace) {
      if (!mounted) return;
      _addDebug('configure:exception $error');
      _addDebug('configure:stack $stackTrace');
      _showSnackBar('Configuration failed: $error');
    } finally {
      if (!mounted) return;
      setState(() {
        _isConfiguring = false;
        _isInitializingAdvisor = false;
      });
      _addDebug('configure:end');
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending || !_advisorReady) return;
    _addDebug('message:send "$text"');

    setState(() {
      _messages.add(_ChatMessage(role: 'You', text: text));
      _isSending = true;
      _messageController.clear();
    });

    try {
      final result = await _service.sendMessage(text);
      _addDebug('message:result $result');
      if (!mounted) return;

      switch (result) {
        case Success(value: final response):
          _addDebug(
            'message:success id=${response.messageId} thread=${response.threadId} tools=${response.tools}',
          );
          _addDebug('message:raw=${response.rawContent}');
          _addDebug('message:markup=${response.markupContent}');
          final responseText = _extractAdvisorMessage(response);
          setState(() {
            _messages.add(_ChatMessage(role: 'Advisor', text: responseText));
          });
          break;
        case Error(message: final message):
          _addDebug('message:error=$message');
          setState(() {
            _messages.add(
              _ChatMessage(
                role: 'Advisor',
                text: 'Unable to get response. $message',
              ),
            );
          });
          break;
      }
    } catch (error, stackTrace) {
      if (!mounted) return;
      _addDebug('message:exception $error');
      _addDebug('message:stack $stackTrace');
      setState(() {
        _messages.add(
          _ChatMessage(
            role: 'Advisor',
            text: 'Error while sending message: $error',
          ),
        );
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isSending = false;
      });
      _addDebug('message:end');
    }
  }

  Future<void> _detectNutritionFromCamera() async {
    if (_passioStatus?.mode != PassioMode.isReadyForDetection) {
      _showSnackBar('Please configure SDK first.');
      return;
    }

    try {
      final bytes = await _captureImageWithInAppCamera();
      if (bytes == null) {
        _addDebug('camera:inApp cancelled');
        return;
      }

      await _processDetectedImageBytes(bytes, source: 'camera');
    } on PlatformException catch (error, stackTrace) {
      final message = '${error.message ?? error.code}'.toLowerCase();
      final isChannelError =
          message.contains('unable to establish connection') ||
          error.code.toLowerCase().contains('channel-error');
      if (!mounted) return;
      setState(() {
        _detectionError = '$error';
      });
      _addDebug('camera:platformException=$error');
      _addDebug('camera:stack=$stackTrace');
      if (isChannelError ||
          error.code.toLowerCase().contains('camera_access_denied')) {
        _showSnackBar(
          'Camera unavailable. Fallback image picker open kar raha hu.',
        );
        await _detectNutritionFromFileFallback();
        return;
      }
      _showSnackBar('Camera detection failed: $error');
    } catch (error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _detectionError = '$error';
      });
      _addDebug('camera:error=$error');
      _addDebug('camera:stack=$stackTrace');
      _showSnackBar('Camera detection failed: $error');
    } finally {
      if (!mounted) return;
      setState(() {
        _isDetectingCamera = false;
      });
    }
  }

  Future<void> _detectNutritionFromFileFallback() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: false,
      );
      if (result == null || result.files.isEmpty) {
        _addDebug('fallback:filePicker cancelled');
        return;
      }

      final filePath = result.files.first.path;
      if (filePath == null || filePath.isEmpty) {
        _addDebug('fallback:filePicker path missing');
        _showSnackBar('Unable to read selected file path.');
        return;
      }

      final file = File(filePath);
      if (!await file.exists()) {
        _addDebug('fallback:filePicker file not found path=$filePath');
        _showSnackBar('Selected image file not found.');
        return;
      }

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        _addDebug('fallback:filePicker empty bytes');
        _showSnackBar('Selected image data not available.');
        return;
      }

      await _processDetectedImageBytes(bytes, source: 'fallback');
    } catch (error, stackTrace) {
      if (!mounted) return;
      setState(() {
        _detectionError = '$error';
      });
      _addDebug('fallback:error=$error');
      _addDebug('fallback:stack=$stackTrace');
      _showSnackBar('Fallback detection failed: $error');
    } finally {
      if (!mounted) return;
      setState(() {
        _isDetectingCamera = false;
      });
    }
  }

  Future<Uint8List?> _captureImageWithInAppCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _showSnackBar('No camera available on this device.');
      return null;
    }

    final rearCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    return Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => NutritionCameraCaptureScreen(camera: rearCamera),
      ),
    );
  }

  Future<void> _processDetectedImageBytes(
    Uint8List bytes, {
    required String source,
  }) async {
    _addDebug('$source:image bytes=${bytes.length}');

    if (bytes.length > _maxImageBytes) {
      _showSnackBar(
        'Image too large (${(bytes.length / (1024 * 1024)).toStringAsFixed(1)}MB). Use image under 6MB.',
      );
      _addDebug('$source:image rejected large size=${bytes.length}');
      return;
    }

    if (!mounted) return;
    setState(() {
      _isDetectingCamera = true;
      _detectionError = null;
      _detectedNutritionItem = null;
    });

    try {
      final foods = await _service.recognizeFoodFromImage(bytes);

      // Log detected candidates
      for (final food in foods) {
        _addDebug(
          'detected: name=${food.recognisedName} productCode=${food.productCode ?? '-'} packaged=${food.packagedFoodItem != null} dataInfo=${food.foodDataInfo != null}',
        );
      }

      PassioFoodItem? nutritionFacts = await _service.recognizeNutritionFacts(
        bytes,
      );
      if (nutritionFacts == null) {
        _addDebug('recognizeNutritionFacts returned null, retrying once');
        try {
          nutritionFacts = await _service.recognizeNutritionFacts(bytes);
        } catch (e) {
          _addDebug('recognizeNutritionFacts retry error: $e');
        }
      }

      // Prepare concurrent fetches with timeouts in resolver
      final resolvedNutrition = await _resolveNutritionItem(
        foods: foods,
        nutritionFacts: nutritionFacts,
      );

      if (!mounted) return;
      final previewStr = _buildPreviewString(
        foods: foods,
        resolved: resolvedNutrition,
        nutritionFacts: nutritionFacts,
      );

      if (!mounted) return;
      setState(() {
        _detectedFoods = foods;
        _detectedNutritionItem = resolvedNutrition;
        _detectedPreviewString = previewStr;
      });

      _addDebug(
        '$source:detected foods=${foods.length} nutritionFacts=${resolvedNutrition != null}',
      );
      _showSnackBar('Detection completed.');
    } finally {
      if (!mounted) return;
      setState(() {
        _isDetectingCamera = false;
      });
    }
  }

  Future<PassioFoodItem?> _resolveNutritionItem({
    required List<PassioAdvisorFoodInfo> foods,
    required PassioFoodItem? nutritionFacts,
  }) async {
    if (nutritionFacts != null) return nutritionFacts;

    if (foods.isEmpty) {
      _addDebug('nutrition:no foods to resolve');
      return null;
    }

    // Favor any packaged item returned directly by the detector
    for (final food in foods) {
      if (food.packagedFoodItem != null) {
        _addDebug(
          'nutrition:using packagedFoodItem for ${food.recognisedName}',
        );
        return food.packagedFoodItem;
      }
    }

    // Start concurrent fetches for productCode and foodDataInfo candidates.
    final fetchFutures = <Future<PassioFoodItem?>>[];

    for (final food in foods) {
      if (food.productCode != null && food.productCode!.isNotEmpty) {
        final code = food.productCode!;
        _addDebug('nutrition:queue productCode fetch for $code');
        fetchFutures.add(
          _service.fetchFoodItemFromProductCode(code).catchError((e) {
            _addDebug('nutrition:productCode fetch error for $code: $e');
            return null;
          }),
        );
      }

      if (food.foodDataInfo != null) {
        _addDebug('nutrition:queue dataInfo fetch for ${food.recognisedName}');
        fetchFutures.add(
          _service.fetchFoodItemFromDataInfo(food.foodDataInfo!).catchError((
            e,
          ) {
            _addDebug(
              'nutrition:dataInfo fetch error for ${food.recognisedName}: $e',
            );
            return null;
          }),
        );
      }
    }

    if (fetchFutures.isEmpty) {
      _addDebug('nutrition:no productCode or dataInfo candidates');
      return null;
    }

    final completer = Completer<PassioFoodItem?>();

    for (final f in fetchFutures) {
      f.then((res) {
        if (res != null && !completer.isCompleted) {
          completer.complete(res);
        }
      });
    }

    // When all fetches complete, complete with null if nothing found.
    Future.wait(fetchFutures)
        .then((_) {
          if (!completer.isCompleted) completer.complete(null);
        })
        .catchError((_) {
          if (!completer.isCompleted) completer.complete(null);
        });

    final result = await completer.future;
    if (result != null) {
      _addDebug('nutrition:concurrent fetch found ${result.name}');
    } else {
      _addDebug('nutrition:concurrent fetch found nothing');
    }
    return result;
  }

  String _nutritionSummary(PassioFoodItem item) {
    final nutrients = item.nutrientsSelectedSize();
    final calories = _formatEnergy(nutrients.calories);
    final carbs = _formatMass(nutrients.carbs);
    final protein = _formatMass(nutrients.proteins);
    final fat = _formatMass(nutrients.fat);
    final sugar = _formatMass(nutrients.sugars);
    final fiber = _formatMass(nutrients.fibers);
    final sodium = _formatMass(nutrients.sodium);
    return 'Calories: $calories • Carbs: $carbs • Protein: $protein • Fat: $fat\nSugar: $sugar • Fiber: $fiber • Sodium: $sodium';
  }

  String _detectedFoodsTitle() {
    if (_detectedFoods.isEmpty) {
      return 'Detected food: ${_detectedNutritionItem?.name ?? '-'}';
    }

    final names = _detectedFoods.map((e) => e.recognisedName).join(', ');
    return 'Detected foods: $names';
  }

  Future<void> _fetchDetailsForCandidate(PassioAdvisorFoodInfo food) async {
    _addDebug('candidate:fetch start ${food.recognisedName}');
    if (!mounted) return;
    setState(() {
      _isDetectingCamera = true;
      _detectionError = null;
    });

    try {
      // If packaged item present use it immediately
      if (food.packagedFoodItem != null) {
        _addDebug(
          'candidate:using packagedFoodItem for ${food.recognisedName}',
        );
        if (!mounted) return;
        setState(() {
          _detectedNutritionItem = food.packagedFoodItem;
          _detectedPreviewString = _nutritionSummary(food.packagedFoodItem!);
        });
        return;
      }

      PassioFoodItem? fetched;

      if (food.productCode != null && food.productCode!.isNotEmpty) {
        _addDebug('candidate:fetch by productCode ${food.productCode}');
        try {
          fetched = await _service.fetchFoodItemFromProductCode(
            food.productCode!,
          );
        } catch (e) {
          _addDebug('candidate:productCode fetch error $e');
        }
      }

      if (fetched == null && food.foodDataInfo != null) {
        _addDebug('candidate:fetch by dataInfo for ${food.recognisedName}');
        try {
          fetched = await _service.fetchFoodItemFromDataInfo(
            food.foodDataInfo!,
          );
        } catch (e) {
          _addDebug('candidate:dataInfo fetch error $e');
        }
      }

      if (!mounted) return;

      if (fetched != null) {
        _addDebug('candidate:fetch success ${fetched.name}');
        setState(() {
          _detectedNutritionItem = fetched;
          _detectedPreviewString = _nutritionSummary(fetched!);
        });
      } else {
        _addDebug('candidate:fetch returned no details');
        setState(() {
          _detectionError =
              'No detailed nutrition found for ${food.recognisedName}';
        });
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isDetectingCamera = false;
      });
    }
  }

  String? _detectedPreviewSummary() {
    if (_detectedNutritionItem != null || _detectedFoods.isEmpty) {
      return null;
    }
    final withPreview = _detectedFoods.firstWhere(
      (food) => food.foodDataInfo != null,
      orElse: () => _detectedFoods.first,
    );
    final preview = withPreview.foodDataInfo?.nutritionPreview;
    if (preview == null) return null;

    return _formatPreview(preview);
  }

  String _formatPreview(dynamic preview) {
    if (preview == null) return '';
    // Use dynamic access because the preview type may come from the SDK package
    final calories = preview.calories ?? '-';
    String fmt(num? value) => value == null ? '-' : value.toStringAsFixed(1);
    final carbs = fmt(preview.carbs as num?);
    final protein = fmt(preview.protein as num?);
    final fat = fmt(preview.fat as num?);
    final fiber = fmt(preview.fiber as num?);
    return 'Estimated: ${calories} kcal • C: ${carbs}g • P: ${protein}g • F: ${fat}g • Fiber: ${fiber}g';
  }

  String? _buildPreviewString({
    required List<PassioAdvisorFoodInfo> foods,
    required PassioFoodItem? resolved,
    required PassioFoodItem? nutritionFacts,
  }) {
    // If we have a resolved full item, show its full summary
    final item = resolved ?? nutritionFacts;
    if (item != null) return _nutritionSummary(item);

    if (foods.isEmpty) return null;

    // Prefer an available nutritionPreview from foodDataInfo
    final withPreview = foods.firstWhere(
      (food) => food.foodDataInfo?.nutritionPreview != null,
      orElse: () => foods.first,
    );

    final preview = withPreview.foodDataInfo?.nutritionPreview;
    if (preview != null) return _formatPreview(preview);

    // If a packaged item is present on any candidate, use it
    final packaged = foods
        .firstWhere(
          (f) => f.packagedFoodItem != null,
          orElse: () => foods.first,
        )
        .packagedFoodItem;
    if (packaged != null) return _nutritionSummary(packaged);

    // No preview available
    return null;
  }

  String _formatMass(UnitMass? mass) {
    if (mass == null) return '-';
    return '${mass.value.toStringAsFixed(1)} ${mass.symbol}';
  }

  String _formatEnergy(UnitEnergy? energy) {
    if (energy == null) return '-';
    return '${energy.value.toStringAsFixed(0)} ${energy.symbol}';
  }

  void _addDebug(String log) {
    debugPrint('[NutritionAI] $log');
    if (!mounted) return;
    setState(() {
      _debugLogs.insert(0, '${DateTime.now().toIso8601String()}  $log');
      if (_debugLogs.length > 30) {
        _debugLogs.removeLast();
      }
    });
  }

  String _extractAdvisorMessage(PassioAdvisorResponse response) {
    final markup = response.markupContent.trim();
    if (markup.isNotEmpty) return markup;

    final raw = response.rawContent.trim();
    if (raw.isNotEmpty) return raw;

    return 'Response received.';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _passioStatus == null
        ? 'Not configured'
        : '${_passioStatus!.mode.name}${_passioStatus!.error == null ? '' : ' • error: ${_passioStatus!.error!.name}'}${_passioStatus!.debugMessage == null ? '' : ' • ${_passioStatus!.debugMessage}'}';

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition AI')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 32,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  TextField(
                    controller: _sdkKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Passio SDK Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isConfiguring || _isInitializingAdvisor)
                          ? null
                          : _configureAndInitAdvisor,
                      child: Text(
                        (_isConfiguring || _isInitializingAdvisor)
                            ? 'Setting up...'
                            : 'Configure & Start Advisor',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isDetectingCamera
                          ? null
                          : _detectNutritionFromCamera,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(
                        _isDetectingCamera
                            ? 'Detecting from camera...'
                            : 'Detect Nutrition From Camera',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Status: $statusText'),
                  ),
                  if (_detectionError != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Detection error: $_detectionError',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  if (_detectedFoods.isNotEmpty ||
                      _detectedNutritionItem != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _detectedFoodsTitle(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Candidate chooser: show chips for each detected food so user can force-resolve
                    if (_detectedFoods.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: _detectedFoods.map((food) {
                            return ActionChip(
                              label: Text(food.recognisedName),
                              onPressed: _isDetectingCamera
                                  ? null
                                  : () => _fetchDetailsForCandidate(food),
                            );
                          }).toList(),
                        ),
                      ),
                    if (_detectedFoods.isNotEmpty &&
                        _detectedNutritionItem == null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            'Tap a detected item to fetch full nutrition details.',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    if (_detectedPreviewString != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _detectedPreviewString!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (_detectedNutritionItem != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _nutritionSummary(_detectedNutritionItem!),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _debugLogs.isEmpty
                        ? const Text('Debug logs will appear here.')
                        : ListView.builder(
                            itemCount: _debugLogs.length,
                            itemBuilder: (context, index) {
                              return Text(
                                _debugLogs[index],
                                style: const TextStyle(fontSize: 11),
                              );
                            },
                          ),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: _messages.isEmpty
                        ? const Center(
                            child: Text(
                              'No messages yet. Ask nutrition questions below.',
                            ),
                          )
                        : ListView.builder(
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final item = _messages[index];
                              return ListTile(
                                dense: true,
                                title: Text(item.role),
                                subtitle: Text(item.text),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a nutrition question...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: (_advisorReady && !_isSending)
                            ? _sendMessage
                            : null,
                        child: _isSending
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Send'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PassioDebugStatusListener implements PassioStatusListener {
  _PassioDebugStatusListener({required this.onLog});

  final void Function(String log) onLog;

  @override
  void onPassioStatusChanged(PassioStatus status) {
    onLog('listener:statusChanged $status');
  }

  @override
  void onCompletedDownloadingAllFiles(List<Uri> fileUris) {
    onLog('listener:allFilesDownloaded count=${fileUris.length}');
  }

  @override
  void onCompletedDownloadingFile(Uri fileUri, int filesLeft) {
    onLog('listener:fileDownloaded uri=$fileUri filesLeft=$filesLeft');
  }

  @override
  void onDownloadError(String message) {
    onLog('listener:downloadError=$message');
  }
}

class _ChatMessage {
  const _ChatMessage({required this.role, required this.text});

  final String role;
  final String text;
}
