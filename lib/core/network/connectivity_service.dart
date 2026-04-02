import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity();

  final Connectivity _connectivity;

  /// Stream that emits true when online, false when offline
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnectivity);
  }

  Future<bool> get hasConnectivity async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnectivity(results);
  }

  bool _hasConnectivity(List<ConnectivityResult> results) {
    return results.every((r) => r != ConnectivityResult.none);
  }
}
