from django.urls import path
from .views import (
    ProductListView,
    ProductRetrieveView,
    PaymentMethodListView,
    DiscountListView,
    OrderCreateAPIView
)

urlpatterns = [
    path('products/', ProductListView.as_view()),
    path('products/<int:pk>/', ProductRetrieveView.as_view()),
    path('payment-methods/', PaymentMethodListView.as_view()),
    path('discounts/', DiscountListView.as_view()),
    path('orders/', OrderCreateAPIView.as_view()),
]