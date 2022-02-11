import 'dart:convert';
import 'dart:io';

import 'package:app/redux/models/cart/cart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderService {
  final Dio _dio;

  const OrderService(this._dio);

  dynamic addOrder(List<Item> items) async {
    var link = dotenv.env['API_ROOT']! + '/orders/';

    var data = {
      'order_details': items.map((item) => {
        'product': item.product.id,
        'quantity': item.total
      }).toList()
    };

    try {
      var response = await _dio.post(
        link,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data)
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to create order');
    }
  }
}