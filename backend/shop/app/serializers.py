from rest_framework import serializers
from .models import (
    Product,
    PaymentMethod,
    Discount,
    Order,
    OrderDetail,
)


class ProductSerializer(serializers.ModelSerializer):

    class Meta:
        model = Product
        fields = [
            'id',
            'name',
            'avatar',
            'price',
            'type',
            'desc',
            'sku',
            'type',
            'create_at',
        ]


class PaymentMethodSerializer(serializers.ModelSerializer):

    class Meta:
        model = PaymentMethod
        fields = '__all__'


class DiscountSerializer(serializers.ModelSerializer):

    class Meta:
        model = Discount
        fields = [
            'id',
            'name',
            'desc',
            'discount_percent',
        ]


class OrderDetailCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderDetail
        fields = [
            'product',
            'quantity',
        ]


class OrderCreateSerializer(serializers.ModelSerializer):
    order_details = serializers.ListField(child=OrderDetailCreateSerializer())

    class Meta:
        model = Order
        fields = [
            'user',
            'order_details',
        ]

    def create(self, validated_data):
        order_details = validated_data.pop('order_details')

        instance = super().create(validated_data)

        print(order_details)

        for order_detail in order_details:
            product = order_detail['product']
            price = product.price * order_detail['quantity']
            OrderDetail.objects.create(order=instance, product=product, quantity=order_detail['quantity'], price=price)

        return instance