import 'package:app/helpers/dio.dart';
import 'package:app/helpers/interceptors.dart';
import 'package:app/redux/reducer.dart';
import 'package:app/service/authentication.dart';
import 'package:app/service/order.dart';
import 'package:dio/dio.dart';
import "package:redux/redux.dart";
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

import 'app_state.dart';
import 'models/cart/cart_middleware.dart';
import 'models/user/user_middleware.dart';

Future<Store<AppState>> getStore() async {
  Dio dio = getDio();

  AuthenticationService authenticationService = AuthenticationService();
  OrderService orderService = OrderService(dio);

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(location: FlutterSaveLocation.sharedPreferences), // Or use other engines
    serializer: JsonSerializer<AppState>(AppState.fromJson), // Or use other serializers
  );

  AppState? initialState;
  try {
    initialState = await persistor.load();
  } on SerializationException catch (_) {
    initialState = null;
  }

  List<Middleware<AppState>> middleware = [
    persistor.createMiddleware(),
    ...createUserMiddleware(authenticationService),
    ...createCartMiddleware(orderService),
  ];

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState.init(),
    middleware: middleware,
  );

  initInterceptors(store, dio);

  return store;
}