import 'package:app/redux/models/cart/cart.dart';
import 'package:redux/redux.dart';
import '../../app_state.dart';
import 'cart_action.dart';

final cartReducers = <AppState Function(AppState, dynamic)> [
  TypedReducer<AppState, AddProductAction>(_addProduct),
  TypedReducer<AppState, SetProductTotalAction>(_setProductTotal),
  TypedReducer<AppState, CreateOrderAction>(_createOrder),
];

AppState _addProduct(AppState state, AddProductAction action) {
  try {
    var item = state.cart.items.firstWhere((element) => element.product.id == action.product.id);
    item.total += 1;
  } catch (e) {
    var item = Item(action.product);
    state.cart.items.add(item);
  }

  return state;
}

AppState _setProductTotal(AppState state, SetProductTotalAction action) {
  try {
    var item = state.cart.items.firstWhere((element) => element.product.id == action.productId);

    if (action.total == 0) {
      state.cart.items.remove(item);
    } else {
      item.total = action.total;
    }
  } catch (e) {
    // nothing
  }

  return state;
}


AppState _createOrder(AppState state, CreateOrderAction action) {
  state.cart.items = [];
  state.cart.orderId = action.orderId;
  return state;
}