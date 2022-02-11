import 'package:app/service/order.dart';
import "package:redux/redux.dart";

import '../../app_state.dart';
import 'cart_action.dart';

List<Middleware<AppState>> createCartMiddleware(OrderService orderService) {
  return [
    TypedMiddleware<AppState, CreateOrderAction>(_createOrder(orderService)),
  ];
}

void Function(
    Store<AppState> store,
    CreateOrderAction action,
    NextDispatcher next,
    ) _createOrder(
    OrderService orderService
    ) {
  return (store, action, next) async {
    try {
      var result = await orderService.addOrder(store.state.cart.items);

      action.orderId = result;

      next(action);
    } catch (e) {
      print(e);
      // ignored
    }
  };
}