import 'package:redux/redux.dart';
import 'package:app/redux/app_state.dart';
import 'package:app/redux/models/user/user_action.dart';

final userReducers = <AppState Function(AppState, dynamic)> [
  TypedReducer<AppState, SetAccessTokenAction>(_saveAccessToken),
  TypedReducer<AppState, SetTokenAction>(_saveToken),
];

AppState _saveAccessToken(AppState state, SetAccessTokenAction action) {
  state.user.accessToken = action.accessToken;

  return state;
}

AppState _saveToken(AppState state, SetTokenAction action) {
  state.user.accessToken = action.accessToken;
  state.user.refreshToken = action.refreshToken;
  return state;
}
