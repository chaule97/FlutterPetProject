import 'package:app/models/product.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  final Dio _dio = Dio();

  dynamic getProducts({ int page = 1 }) async {
    var link = dotenv.env['API_ROOT']! + '/products/';

    try {
      var response = await _dio.get(link, queryParameters: { 'page': page });

      var products = List<Product>.from(response.data['results'].map((model)=> Product.fromJson(model)).toList());

      return {
        'count': response.data['count'],
        'next': response.data['next'],
        'previous': response.data['previous'],
        'products': products,
      };
    } catch (e) {
      print(e);
      throw Exception('Failed to load product');
    }
  }

  Future<Product> getProduct(int id) async {
    var link = dotenv.env['API_ROOT']! + '/products/$id/';

    try {
      var response = await _dio.get(link);

      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product');
    }
  }
}