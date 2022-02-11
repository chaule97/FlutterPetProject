import 'package:app/models/product.dart';
import 'package:app/redux/app_state.dart';
import 'package:app/redux/models/cart/cart.dart';
import 'package:app/redux/models/cart/cart_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../routes.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>{

  Future<void> showDeleteItemDialog(Product product) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notification),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${AppLocalizations.of(context)!.doYouWantToDelete} ${product.name}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                dispatchItemTotal(product.id, 0);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.oK),
            ),
          ],
        );
      },
    );
  }

  void dispatchItemTotal (int id, int total) {
    var setProductTotal = SetProductTotalAction(id, total);

    StoreProvider.of<AppState>(context).dispatch(setProductTotal);
  }

  void setItemTotal(Item item, {bool increase = true}) {
    if (!increase && item.total == 1) {
      showDeleteItemDialog(item.product);
    } else {
      dispatchItemTotal(item.product.id, increase ? item.total + 1 : item.total -1);
    }
  }

  void login() {
    Navigator.pushNamed(context, Routes.login, arguments: Routes.cart);
  }

  void addOrder() {
    final createAction = CreateOrderAction();
    StoreProvider.of<AppState>(context).dispatch(createAction);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int?>(
      converter: (store) => store.state.cart.orderId,
      onWillChange: (prev, orderId) {
        if (orderId != prev && orderId != null) {
          Navigator.pushReplacementNamed(context, Routes.createSuccessfully, arguments: orderId);
        }
      },
      builder: (context, orderId) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.cart),
          ),
          body: StoreConnector<AppState, List<Item>>(
            converter: (store) => store.state.cart.items,
            builder: (context, items) {
              if (items.isNotEmpty) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image(
                              image: NetworkImage(items[index].product.avatar),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(items[index].product.name, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 10),
                                Text(NumberFormat.decimalPattern().format(items[index].product.price) + ' VNĐ'),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    InkWell(
                                      child: const Icon(Icons.remove, size: 30.0),
                                      onTap: () => setItemTotal(items[index], increase: false),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      items[index].total.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      child: const Icon(Icons.add, size: 30.0),
                                      onTap: () => setItemTotal(items[index]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ]
                      )
                    );
                  }
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 250),
                    const SizedBox(height: 75),
                    Text(
                      AppLocalizations.of(context)!.youHaveNotItemInCartYet,
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.home);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        color: Colors.deepOrange,
                        child: Text(
                          AppLocalizations.of(context)!.continueBuy.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          ),
          bottomNavigationBar: StoreConnector<AppState, int>(
            converter: (store) => store.state.cart.items.length,
            builder: (context, count) {
              if (count == 0) {
                return const BottomAppBar();
              }
              return BottomAppBar(
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        height: 35,
                        color: Colors.teal,
                        child: Center(
                          child: StoreConnector<AppState, double>(
                            converter: (store) => store.state.cart.items.fold(0, (value, element) => value + element.total * element.product.price),
                            builder: (context, total) {
                              return Text(
                                "${NumberFormat.decimalPattern().format(total)} VNĐ",
                                style: const TextStyle(color: Colors.white),
                              );
                            }
                          )
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: StoreConnector<AppState, bool>(
                        converter: (store) => store.state.user.refreshToken.isNotEmpty,
                        builder: (context, isLogin) {
                          return GestureDetector(
                            onTap: isLogin ? addOrder : login,
                            child: Container(
                              height: 35,
                              color: Colors.deepOrange,
                              child: Center(
                                child: Text(
                                  isLogin ? AppLocalizations.of(context)!.createOrder : AppLocalizations.of(context)!.login,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          );
                        }
                      ),
                    )
                  ],
                )
              );
            }
          )
        );
      }
    );
  }
}