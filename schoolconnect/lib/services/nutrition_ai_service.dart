import 'dart:async';
import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

typedef NutritionAiLogger = void Function(String message);

class NutritionAiService {
  NutritionAiService({this.logger});

  final NutritionAiLogger? logger;

  Future<String?> getSdkVersion() {
    return NutritionAI.instance.getSDKVersion();
  }

  void setStatusListener(PassioStatusListener? listener) {
    NutritionAI.instance.setPassioStatusListener(listener);
  }

  Future<PassioStatus> configureForAdvisor({
    required String key,
    int debugMode = 1,
  }) async {
    const maxAttempts = 3;
    PassioStatus? lastStatus;

    final configuration = PassioConfiguration(
      key,
      debugMode: debugMode,
      allowInternetConnection: true,
    );

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      logger?.call('configure:attempt=$attempt/$maxAttempts');
      final status = await NutritionAI.instance.configureSDK(configuration);
      lastStatus = status;
      logger?.call('configure:result=$status');

      if (!_shouldRetry(status) || attempt == maxAttempts) {
        return status;
      }

      final waitSeconds = attempt * 2;
      logger?.call('configure:retryAfter=${waitSeconds}s');
      await Future<void>.delayed(Duration(seconds: waitSeconds));
    }

    return lastStatus ?? const PassioStatus(mode: PassioMode.failedToConfigure);
  }

  Future<PassioResult<void>> initAdvisor() {
    return NutritionAdvisor.instance.initConversation();
  }

  Future<PassioResult<PassioAdvisorResponse>> sendMessage(String message) {
    return NutritionAdvisor.instance.sendMessage(message);
  }

  Future<List<PassioAdvisorFoodInfo>> recognizeFoodFromImage(Uint8List bytes) {
    return NutritionAI.instance.recognizeImageRemote(bytes);
  }

  Future<PassioFoodItem?> recognizeNutritionFacts(Uint8List bytes) {
    return NutritionAI.instance.recognizeNutritionFactsRemote(bytes);
  }

  Future<PassioFoodItem?> fetchFoodItemFromDataInfo(
    PassioFoodDataInfo dataInfo,
  ) {
    return NutritionAI.instance.fetchFoodItemForDataInfo(dataInfo);
  }

  Future<PassioFoodItem?> fetchFoodItemFromProductCode(String productCode) {
    return NutritionAI.instance.fetchFoodItemForProductCode(productCode);
  }

  bool _shouldRetry(PassioStatus status) {
    if (status.mode != PassioMode.failedToConfigure) return false;

    final debug = (status.debugMessage ?? '').toLowerCase();
    return debug.contains('network connection was lost') ||
        debug.contains('timed out') ||
        debug.contains('cannot parse response');
  }
}
