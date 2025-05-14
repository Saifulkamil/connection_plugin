// main.dart - Fix the method call
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
      // Fixed method call from getConnectionLantency to getConnectionLatency
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
        _latency = 0;
        _status = "Unknown error occurred: ${e.toString()}"; // Added error message
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
