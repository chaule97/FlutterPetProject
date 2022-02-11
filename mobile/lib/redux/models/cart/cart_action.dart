import 'package:app/models/product.dart';

class AddProductAction {
  final Product product;

  AddProductAction(this.product);
}

class SetProductTotalAction {
  final int productId;
  final int total;

  SetProductTotalAction(this.productId, this.total);
}

class CreateOrderAction {
  late int orderId;
}