// connection_plugin_platform_interface.dart - Fix the method name
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'connection_plugin_method_channel.dart';

abstract class ConnectionPluginPlatform extends PlatformInterface {
  /// Constructs a ConnectionPluginPlatform.
  ConnectionPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ConnectionPluginPlatform _instance = MethodChannelConnectionPlugin();

  /// The default instance of [ConnectionPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelConnectionPlugin].
  static ConnectionPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ConnectionPluginPlatform] when
  /// they register themselves.
  static set instance(ConnectionPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // Fixed method name from getConnectionLantency to getConnectionLatency
  Future<int?> getConnectionLatency(String url) {
    throw UnimplementedError('getConnectionLatency() has not been implemented.');
  }
}