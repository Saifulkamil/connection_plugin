
import 'connection_plugin_platform_interface.dart';

class ConnectionPlugin {
  Future<String?> getPlatformVersion() {
    return ConnectionPluginPlatform.instance.getPlatformVersion();
  }

   Future<int?> getConnectionLatency(String url) {
    return ConnectionPluginPlatform.instance.getConnectionLatency(url);
  }
}
