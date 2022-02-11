class User {
  String accessToken;
  String refreshToken;

  User(this.accessToken, this.refreshToken);

  User copyWith() {
    return User(accessToken, refreshToken);
  }

  dynamic toJson() => {'accessToken': accessToken, 'refreshToken': refreshToken};
}