import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veerens_floating_api/src/api_log_store.dart';
import 'package:veerens_floating_api/src/platform/veerens_store_guard.dart';
import 'package:veerens_floating_api/veerens_floating_api.dart';

const MethodChannel _storeGuardChannel = MethodChannel('veerens_floating_api');

ApiLogEntry _entry(String id) => ApiLogEntry(
      id: id,
      timestamp: DateTime.now(),
      method: 'GET',
      url: 'https://example.com/$id',
      statusCode: 200,
      responseBody: const <String, dynamic>{'ok': true},
    );

void _mockStoreInstall(bool isStoreInstall) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    _storeGuardChannel,
    (MethodCall call) async => call.method == 'isStoreInstall' ? isStoreInstall : null,
  );
}

Widget _demoApp() {
  return MaterialApp(
    navigatorObservers: <NavigatorObserver>[VeerensFloatingApi.routeObserver],
    builder: VeerensFloatingApi.builder(enabled: true),
    home: const Scaffold(body: Center(child: Text('Home'))),
  );
}

void main() {
  setUp(() {
    VeerensApiLogStore.instance.clear();
    VeerensStoreGuard.debugResetForTesting();
    _mockStoreInstall(false);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      _storeGuardChannel,
      null,
    );
  });

  group('VeerensApiLogStore', () {
    test('stores entries and exposes them latest-first', () {
      final VeerensApiLogStore store = VeerensApiLogStore.instance;
      store.add(_entry('1'));
      store.add(_entry('2'));

      expect(store.latest?.id, '2');
      expect(store.entries.map((ApiLogEntry e) => e.id).toList(), <String>['2', '1']);
    });

    test('clear empties history', () {
      final VeerensApiLogStore store = VeerensApiLogStore.instance;
      store.add(_entry('1'));
      store.clear();

      expect(store.entries, isEmpty);
      expect(store.latest, isNull);
    });
  });

  group('VeerensFloatingApi overlay', () {
    testWidgets('shows the floating button and opens the inspector on tap', (
      WidgetTester tester,
    ) async {
      VeerensApiLogStore.instance.add(_entry('1'));

      await tester.pumpWidget(_demoApp());
      await tester.pump();
      await tester.pump(); // let the async automatic store-install check resolve

      expect(find.text('V'), findsOneWidget);

      await tester.tap(find.text('V'));
      await tester.pumpAndSettle();

      expect(find.text('Latest API Call'), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
    });

    testWidgets('long press hides the button on the current page', (WidgetTester tester) async {
      await tester.pumpWidget(_demoApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('V'), findsOneWidget);

      await tester.longPress(find.text('V'));
      await tester.pump();

      expect(find.text('V'), findsNothing);
    });

    testWidgets('stays hidden when the automatic check reports a real store install', (
      WidgetTester tester,
    ) async {
      _mockStoreInstall(true);

      await tester.pumpWidget(_demoApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('V'), findsNothing);
    });

    testWidgets('stays hidden when the manual flag is off, even if not a store install', (
      WidgetTester tester,
    ) async {
      _mockStoreInstall(false);

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: <NavigatorObserver>[VeerensFloatingApi.routeObserver],
          builder: VeerensFloatingApi.builder(enabled: false),
          home: const Scaffold(body: Center(child: Text('Home'))),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('V'), findsNothing);
    });
  });
}
