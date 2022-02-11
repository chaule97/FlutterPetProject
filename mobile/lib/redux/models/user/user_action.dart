import 'package:flutter/cupertino.dart';

class LoginAction {
  final String username;
  final String password;

  LoginAction(this.username, this.password);
}

class RefreshTokenAction {
  final String token;

  RefreshTokenAction(this.token);
}

class SetAccessTokenAction {
  final String accessToken;

  SetAccessTokenAction(this.accessToken);
}

class SetTokenAction {
  final String accessToken;
  final String refreshToken;

  SetTokenAction(this.accessToken, this.refreshToken);
}

class SetLocaleAction {
  final Locale locale;

  SetLocaleAction(this.locale);
}