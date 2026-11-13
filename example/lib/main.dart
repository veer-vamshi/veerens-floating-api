import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:veerens_floating_api/veerens_floating_api.dart';

/// One shared Dio instance, used everywhere, logged by the interceptor.
final Dio dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'))
  ..interceptors.add(VeerensApiInterceptor());

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'veerens_floating_api example',
      theme: ThemeData(colorSchemeSeed: Colors.blueAccent, useMaterial3: true),
      navigatorObservers: <NavigatorObserver>[VeerensFloatingApi.routeObserver],
      // `enabled: true` forces the button on for this demo, including
      // release builds. In your real app, leave it unset to default to
      // debug-only, or drive it from your own build flavor / dart-define
      // so it still shows in a testing APK but not in your store build.
      builder: VeerensFloatingApi.builder(enabled: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  String? _lastResult;

  Future<void> _call(Future<Response<dynamic>> Function() request) async {
    setState(() => _loading = true);
    try {
      final Response<dynamic> response = await request();
      setState(() => _lastResult = '${response.requestOptions.method} → ${response.statusCode}');
    } catch (e) {
      setState(() => _lastResult = 'Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('veerens_floating_api demo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Drag the black button anywhere.\n'
                'Tap it to inspect the latest API call.\n'
                'Long-press it to hide it on this page only.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _loading ? null : () => _call(() => dio.get<dynamic>('/posts/1')),
                    child: const Text('GET /posts/1'),
                  ),
                  ElevatedButton(
                    onPressed: _loading ? null : () => _call(() => dio.get<dynamic>('/users')),
                    child: const Text('GET /users'),
                  ),
                  ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () => _call(
                            () => dio.post<dynamic>(
                              '/posts',
                              data: <String, dynamic>{
                                'title': 'Veeren\'s floating API',
                                'body': 'Hello from the example app!',
                                'userId': 1,
                              },
                            ),
                          ),
                    child: const Text('POST /posts'),
                  ),
                  ElevatedButton(
                    onPressed: _loading ? null : () => _call(() => dio.get<dynamic>('/posts/999999')),
                    child: const Text('GET (404)'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_loading) const CircularProgressIndicator(),
              if (_lastResult != null) Text(_lastResult!),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const SecondPage()),
                ),
                child: const Text('Open another screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Just to show the same floating button follows you across screens,
/// keeping whatever position you last dragged it to.
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Another screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Same floating button, same position, new screen.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => dio.get<dynamic>('/comments/1'),
                child: const Text('GET /comments/1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
