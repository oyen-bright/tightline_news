import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tightline_news/core/network/cubit/network_cubit.dart';
import 'package:tightline_news/core/network/cubit/network_state.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, networkState) {
        if (networkState.isOnline || Platform.isIOS) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: context.h(10),
            horizontal: context.w(16),
          ),
          color: Theme.of(context).colorScheme.errorContainer,
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: context.r(16),
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                SizedBox(width: context.w(8)),
                Text(
                  'No internet connection',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
