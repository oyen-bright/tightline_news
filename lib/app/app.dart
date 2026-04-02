import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tightline_news/core/di/injection.dart';
import 'package:tightline_news/core/network/cubit/network_cubit.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_cubit.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkCubit>(create: (_) => getIt<NetworkCubit>()),
        BlocProvider<ArticleCubit>(
          create: (_) => getIt<ArticleCubit>()..loadTopHeadlines(),
        ),
      ],
      child: MaterialApp(
        title: 'Tightline News',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}
