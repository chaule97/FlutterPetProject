import 'package:app/redux/models/user/user.dart';
import 'models/cart/cart.dart';

class AppState {
  User user;
  Cart cart;

  AppState(this.user, this.cart);

  factory AppState.init() {
    var user = User('', '');
    var cart = Cart([]);

    return AppState(
      user,
      cart
    );
  }

  static AppState fromJson(dynamic data) {
    if (data != null) {
      User user = User(
          data["user"]["accessToken"], data["user"]["refreshToken"]);

      return AppState(user, Cart([]));
    }

    return AppState.init();
  }

  dynamic toJson() => {'user': user.toJson()};
}