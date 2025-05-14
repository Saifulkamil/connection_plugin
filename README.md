# Connection Plugin

A Flutter plugin that allows your app to measure network latency to specified URLs. This plugin works on Android platforms and provides a simple interface for checking connection performance.

## Features

- Measure connection latency to any URL
- Get real-time latency measurements in milliseconds
- Simple API for easy integration into your Flutter app
- Native implementation for optimal performance

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  connection_plugin: ^0.1.0
```

Then run:

```
flutter pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:connection_plugin/connection_plugin.dart';
```

### Basic Usage

```dart
final connectionPlugin = ConnectionPlugin();

try {
  // Get latency to a specific URL (result in milliseconds)
  final int? latency = await connectionPlugin.getConnectionLatency('https://www.google.com');
  
  if (latency != null) {
    print('Connection latency: $latency ms');
  }
} on PlatformException catch (e) {
  print('Error checking latency: ${e.message}');
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:connection_plugin/connection_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _latency = 0;
  String _status = "Not tested";
  final _connectionPlugin = ConnectionPlugin();
  final _urlController = TextEditingController(text: "https://www.google.com");

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _checkLatency() async {
    setState(() {
      _status = "Testing connection...";
    });

    try {
      final latency = await _connectionPlugin.getConnectionLatency(_urlController.text);

      setState(() {
        _latency = latency ?? 0;
        _status = "Connection successful";
      });
    } on PlatformException catch (e) {
      setState(() {
        _latency = 0;
        _status = "Error: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _status = "Unknown error occurred";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Connection Latency Tester')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://www.google.com',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _checkLatency, child: const Text('Check Latency')),
              const SizedBox(height: 20),
              Text('Status: $_status'),
              const SizedBox(height: 10),
              Text(
                'Latency: $_latency ms',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### ConnectionPlugin

#### `Future<String?> getPlatformVersion()`

Returns the platform version.

#### `Future<int?> getConnectionLatency(String url)`

Measures the connection latency to the specified URL.

Parameters:
- `url`: The URL to test connection latency (e.g., "https://www.google.com")

Returns:
- `Future<int?>`: The latency in milliseconds or null if there was an error

## Troubleshooting

### Unknown error occurred

If you're seeing "Unknown error occurred" in your app, check the following:

1. Make sure the URL format is correct and includes the protocol (http:// or https://)
2. Verify that your app has internet permissions in the AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

3. Check that the URL is reachable and not blocked by network policies
4. For debugging, add more specific error handling in your code

### Method not implemented

If you encounter a "MissingPluginException" or "Method not implemented" error:

1. Ensure you've properly registered the plugin in your project
2. Try running `flutter clean` and then `flutter pub get`
3. Restart your Flutter development server

## Platform Support

- ✅ Android
- ❌ iOS (Coming soon)
- ❌ Web (Not planned)
- ❌ macOS (Not planned)
- ❌ Windows (Not planned)
- ❌ Linux (Not planned)

## License

This plugin is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request