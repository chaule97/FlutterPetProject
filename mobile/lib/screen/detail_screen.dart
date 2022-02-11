import 'package:app/models/product.dart';
import 'package:app/redux/app_state.dart';
import 'package:app/redux/models/cart/cart_action.dart';
import 'package:app/service/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../routes.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailScreen> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin{
  late Future<Product> futureProduct;
  late Product product;
  late AnimationController _colorAnimationController;
  late Animation _colorTween;

  final ProductService service = ProductService();

  @override
  void initState() {
    super.initState();
    futureProduct = service.getProduct(widget.id);
    futureProduct.then((value) => product = value);

    _colorAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _colorTween = ColorTween(
        begin: Colors.transparent, end: Colors.red
    ).animate(_colorAnimationController);
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {

      if (scrollInfo.metrics.pixels > 0) {
        _colorAnimationController.forward();
      } else {
        _colorAnimationController.reverse();
      }
    }
    return true;
  }

  void addProduct () {
    var action = AddProductAction(product);
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    StoreProvider.of<AppState>(context).dispatch(action);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.added}!'),
      ),
    );
  }

  void buy () {
    addProduct();
    Navigator.pushNamed(context, Routes.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) => Container(
            color: _colorTween.value,
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {}
                ),
              ],
            ),
          )
        ),
        preferredSize: const Size.fromHeight(50.0),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: SingleChildScrollView(
          child: FutureBuilder<Product>(
              future: futureProduct,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Image(
                        image: NetworkImage(snapshot.data!.avatar),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Text(
                                  snapshot.data!.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: Text(
                                NumberFormat.decimalPattern().format(snapshot.data!.price) + ' VNĐ',
                                style: const TextStyle(color: Colors.redAccent, fontSize: 15),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(bottom: 10), child: Text(AppLocalizations.of(context)!.productDescription)),
                            Text(snapshot.data!.desc)
                          ],
                        ),
                      )
                    ],
                  );
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
              onTap: addProduct,
                child: Container(
                  height: 35,
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.addCart,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: GestureDetector(
                onTap: buy,
                child: Container(
                  height: 35,
                  color: Colors.deepOrange,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.buyNow,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ),
            ),
          ],
        )
      )
    );
  }
}