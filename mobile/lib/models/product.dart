class Product {
  final int id;
  final String name;
  final String avatar;
  final String desc;
  final int type;
  final String sku;
  final double price;
  final String createAt;

  const Product({
    required this.id,
    required this.name,
    required this.avatar,
    required this.desc,
    required this.type,
    required this.sku,
    required this.price,
    required this.createAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      desc: json['desc'],
      type: json['type'],
      sku: json['sku'],
      price: json['price'],
      createAt: json['createAt'],
    );
  }
}