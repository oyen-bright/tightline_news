class NetworkState {
  const NetworkState({required this.isOnline});

  final bool isOnline;

  NetworkState copyWith({bool? isOnline}) {
    return NetworkState(isOnline: isOnline ?? this.isOnline);
  }
}
