
import 'package:app/redux/app_state.dart';
import 'package:app/redux/models/user/user_action.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';

void initInterceptors(Store<AppState> store, Dio dio) {
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      String accessToken = store.state.user.accessToken;
      if (accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      return handler.next(options);
    },
    onError: (DioError e, handler) async {
      // Expired Token
      if (e.response?.statusCode == 401) {
        String token = store.state.user.refreshToken;

        await store.dispatch(RefreshTokenAction(token));

        String accessToken = store.state.user.accessToken;

        if (accessToken.isNotEmpty) {
          RequestOptions options = e.response!.requestOptions;
          options.headers["Authorization"] = "Bearer " + token;

          final opts = Options(method: options.method, headers: options.headers);

          final cloneReq = await dio.request(
              e.requestOptions.path,
              options: opts,
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters
          );

          return handler.resolve(cloneReq);
        }
      }
      return handler.next(e);
    }
  ));
}