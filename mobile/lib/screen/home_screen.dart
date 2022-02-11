import 'package:app/models/product.dart';
import 'package:intl/intl.dart';
import 'package:app/service/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_bar.dart';
import '../drawer.dart';
import '../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  late Future futureProduct;
  List<Product> products = [];
  int page = 1;
  bool isLoading = false;

  final ProductService service = ProductService();

  Future _loadData() async {
    if (page != 0) {
      isLoading = true;
      var result = await service.getProducts(page: page);
      setState(() {
        products.addAll( result['products']);
        isLoading = false;

        if (result['next'] != null) {
          page += 1;
        } else {
          page = 0;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(),
      body: Column(
        children: [
          Padding(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                prefixIcon: const Icon(Icons.search),
                hintText: AppLocalizations.of(context)!.searchProduct,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          ),
          Expanded(
              child: NotificationListener(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                      _loadData();
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: <Widget>[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom : 10),
                          child: Image(
                              image: NetworkImage('https://salt.tikicdn.com/cache/w750/ts/banner/e0/e9/b5/ead7e0b00375ba827d5a2a58633cf341.png')
                          ),
                        ),
                      ),
                      SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 14.0,
                          ),
                          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.detail, arguments: products[index].id);
                              },
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Image(
                                        image: NetworkImage(products[index].avatar),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      child: Text(products[index].name, overflow: TextOverflow.ellipsis),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                        child: Text(
                                          NumberFormat.decimalPattern().format(products[index].price) + ' VNĐ',
                                          style: const TextStyle(color: Colors.redAccent),
                                        )
                                    ),
                                  ],
                                )
                              )
                            );
                          },
                            childCount: products.length,
                          )
                      )
                    ],
                  )
              ),
          )
        ],
      ),
      drawer:  const DrawerCustom(),
    );
  }
}