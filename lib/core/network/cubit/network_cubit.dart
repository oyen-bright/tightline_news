import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tightline_news/core/network/connectivity_service.dart';
import 'package:tightline_news/core/network/cubit/network_state.dart';

@lazySingleton
class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit(this._connectivityService)
    : super(const NetworkState(isOnline: true)) {
    _init();
  }

  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;

  Future<bool> get currentStatus => _connectivityService.hasConnectivity;

  void _init() {
    _subscription = _connectivityService.onConnectivityChanged.listen((
      isOnline,
    ) {
      emit(NetworkState(isOnline: isOnline));
    });

    // Check initial state
    _connectivityService.hasConnectivity.then((hasConnectivity) {
      if (!isClosed) {
        emit(NetworkState(isOnline: hasConnectivity));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
