import 'package:app/redux/app_state.dart';
import 'package:app/redux/store.dart';
import 'package:app/routes.dart';
import 'package:app/screen/cart_screen.dart';
import 'package:app/screen/detail_screen.dart';
import 'package:app/screen/home_screen.dart';
import 'package:app/screen/login_screen.dart';
import 'package:app/screen/successful_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Store<AppState> store = await getStore();
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({Key? key, required this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', ''),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white60,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case Routes.login:
              String next = Routes.home;
              if (settings.arguments != null) {
                next = settings.arguments as String;
              }
              return MaterialPageRoute(builder: (context) => LoginScreen(next: next));
            case Routes.home:
              return MaterialPageRoute(builder: (context) => const HomeScreen());
            case Routes.detail:
              int id = 1;
              if (settings.arguments != null) {
                id = settings.arguments as int;
              }
              return MaterialPageRoute(builder: (context) => DetailScreen(id: id));
            case Routes.cart:
              return MaterialPageRoute(builder: (context) => const CartScreen());
            case Routes.createSuccessfully:
              int id = 1;
              if (settings.arguments != null) {
                id = settings.arguments as int;
              }
              return MaterialPageRoute(builder: (context) => SuccessfulOrderScreen(orderId: id));
          }

          return MaterialPageRoute(builder: (context) => const HomeScreen());
        }
      )
    );
  }
}
