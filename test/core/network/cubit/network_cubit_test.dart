import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tightline_news/core/network/connectivity_service.dart';
import 'package:tightline_news/core/network/cubit/network_cubit.dart';
import 'package:tightline_news/core/network/cubit/network_state.dart';

class _MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late _MockConnectivityService service;
  late StreamController<bool> connectivityController;

  setUp(() {
    service = _MockConnectivityService();
    connectivityController = StreamController<bool>();

    when(
      () => service.onConnectivityChanged,
    ).thenAnswer((_) => connectivityController.stream);
    when(() => service.hasConnectivity).thenAnswer((_) async => true);
  });

  tearDown(() {
    connectivityController.close();
  });

  group('NetworkCubit', () {
    test('initial state is online', () {
      final cubit = NetworkCubit(service);
      expect(cubit.state.isOnline, isTrue);
      cubit.close();
    });

    test('emits offline when connectivity is lost', () async {
      final cubit = NetworkCubit(service);
      await Future<void>.delayed(Duration.zero);

      final expectation = expectLater(
        cubit.stream,
        emits(isA<NetworkState>().having((s) => s.isOnline, 'isOnline', false)),
      );

      connectivityController.add(false);

      await expectation;
      await cubit.close();
    });

    test('reflects offline initial connectivity check', () async {
      when(() => service.hasConnectivity).thenAnswer((_) async => false);
      final cubit = NetworkCubit(service);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isOnline, isFalse);
      await cubit.close();
    });

    test('cancels stream subscription on close', () async {
      final cubit = NetworkCubit(service);
      await cubit.close();
      expect(cubit.isClosed, isTrue);
    });
  });
}
