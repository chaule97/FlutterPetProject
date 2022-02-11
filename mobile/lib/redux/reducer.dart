import "package:redux/redux.dart";

import 'app_state.dart';
import 'models/cart/cart_reducer.dart';
import 'models/user/user_reducer.dart';

final appReducer = combineReducers<AppState> ([
  ...userReducers,
  ...cartReducers,
]);