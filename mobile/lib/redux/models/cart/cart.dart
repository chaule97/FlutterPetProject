import 'package:app/models/product.dart';

class Item {
  Product product;
  int total;

  Item(this.product, { this.total = 1 });

  @override
  String toString() {
    return '${product.id} - $total';
  }
}

class Cart {
  List<Item> items;
  int? orderId;

  Cart(this.items);
}