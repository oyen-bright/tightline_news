// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tightline_news/core/network/connectivity_service.dart' as _i911;
import 'package:tightline_news/core/network/cubit/network_cubit.dart' as _i603;
import 'package:tightline_news/core/network/dio_client.dart' as _i985;
import 'package:tightline_news/core/network/interceptors/error_interceptor.dart'
    as _i104;
import 'package:tightline_news/core/network/interceptors/logging_interceptor.dart'
    as _i474;
import 'package:tightline_news/features/news/data/datasources/article_remote_data_source.dart'
    as _i964;
import 'package:tightline_news/features/news/data/repositories/article_repository_impl.dart'
    as _i315;
import 'package:tightline_news/features/news/domain/repositories/article_repository.dart'
    as _i868;
import 'package:tightline_news/features/news/presentation/cubit/article_cubit.dart'
    as _i428;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i104.ErrorInterceptor>(() => _i104.ErrorInterceptor());
    gh.factory<_i474.LoggingInterceptor>(() => _i474.LoggingInterceptor());
    gh.lazySingleton<_i911.ConnectivityService>(
      () => _i911.ConnectivityService(),
    );
    gh.lazySingleton<_i603.NetworkCubit>(
      () => _i603.NetworkCubit(gh<_i911.ConnectivityService>()),
    );
    gh.lazySingleton<_i985.DioClient>(
      () => _i985.DioClient(
        gh<_i474.LoggingInterceptor>(),
        gh<_i104.ErrorInterceptor>(),
      ),
    );
    gh.lazySingleton<_i964.ArticleRemoteDataSource>(
      () => _i964.ArticleRemoteDataSource(gh<_i985.DioClient>()),
    );
    gh.lazySingleton<_i868.ArticleRepository>(
      () => _i315.ArticleRepositoryImpl(gh<_i964.ArticleRemoteDataSource>()),
    );
    gh.factory<_i428.ArticleCubit>(
      () => _i428.ArticleCubit(gh<_i868.ArticleRepository>()),
    );
    return this;
  }
}
