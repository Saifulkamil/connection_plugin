import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'connection_plugin_platform_interface.dart';

/// An implementation of [ConnectionPluginPlatform] that uses method channels.
class MethodChannelConnectionPlugin extends ConnectionPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('connection_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
  @override
  Future<int?> getConnectionLatency(String url) async {
    final latency = await methodChannel.invokeMethod<int>('getLatency', {'url': url});
    return latency;
  }
}
