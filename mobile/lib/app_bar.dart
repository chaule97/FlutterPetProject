import 'package:app/redux/app_state.dart';
import 'package:app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{
  const AppBarCustom({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: const Text("Chau shop"),
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, Routes.cart);
              }
          ),
          StoreConnector<AppState, bool>(
            converter: (store) => store.state.user.refreshToken.isNotEmpty,
            builder: (context, isLogin) {
              if (isLogin) {
                return IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle));
              }

              return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.login);
                  }
              );
            }
          ),

        ]
    );
  }
}