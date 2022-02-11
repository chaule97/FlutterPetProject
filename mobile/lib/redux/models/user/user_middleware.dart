import 'package:app/redux/models/user/user_action.dart';
import 'package:app/service/authentication.dart';
import "package:redux/redux.dart";

import '../../app_state.dart';

List<Middleware<AppState>> createUserMiddleware(AuthenticationService authenticationService) {
  return [
    TypedMiddleware<AppState, LoginAction>(_login(authenticationService)),
    TypedMiddleware<AppState, RefreshTokenAction>(_refresh(authenticationService)),
  ];
}

void Function(
      Store<AppState> store,
      LoginAction action,
      NextDispatcher next,
    ) _login(
      AuthenticationService authenticationService
    ) {
  return (store, action, next) async {
    next(action);

    try {
      // Updates user locale after login.
      var result = await authenticationService.login(action.username, action.password);

      if (result != false) {
        store.dispatch(SetTokenAction(result['access'], result['refresh']));
      }
    } catch (e) {
      // ignored
    }
  };
}

void Function(
      Store<AppState> store,
      RefreshTokenAction action,
      NextDispatcher next,
    ) _refresh(AuthenticationService authenticationService) {
  return (store, action, next) async {
    next(action);

    try {
      // Updates user locale after login.
      var result = await authenticationService.refreshToken(action.token);

      if (result != false) {
        store.dispatch(SetAccessTokenAction(result['access']));
      }
    } catch (e) {
      // ignored
    }
  };
}