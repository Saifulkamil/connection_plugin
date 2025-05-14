import 'package:flutter_test/flutter_test.dart';
import 'package:connection_plugin/connection_plugin.dart';
import 'package:connection_plugin/connection_plugin_platform_interface.dart';
import 'package:connection_plugin/connection_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockConnectionPluginPlatform
    with MockPlatformInterfaceMixin
    implements ConnectionPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> getConnectionLatency(String url) {
    // TODO: implement getConnectionLantency
    throw UnimplementedError();
  }
}

void main() {
  final ConnectionPluginPlatform initialPlatform = ConnectionPluginPlatform.instance;

  test('$MethodChannelConnectionPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelConnectionPlugin>());
  });

  test('getPlatformVersion', () async {
    ConnectionPlugin connectionPlugin = ConnectionPlugin();
    MockConnectionPluginPlatform fakePlatform = MockConnectionPluginPlatform();
    ConnectionPluginPlatform.instance = fakePlatform;

    expect(await connectionPlugin.getPlatformVersion(), '42');
  });
}
