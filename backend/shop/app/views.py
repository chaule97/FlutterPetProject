from rest_framework import generics, permissions, viewsets, views
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework import status


from .models import (
    Product,
    PaymentMethod,
    Discount,
)
from .serializers import (
    ProductSerializer,
    PaymentMethodSerializer,
    DiscountSerializer,
    OrderCreateSerializer,
)

# Create your views here.
class ProductPagination(PageNumberPagination):
    page_size = 4
    page_size_query_param = 'page_size'
    max_page_size = 50


class ProductListView(generics.ListAPIView):
    serializer_class = ProductSerializer
    pagination_class = ProductPagination
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        products = Product.objects.all().order_by('-create_at')

        product_type = self.request.GET.get('type', None)

        if product_type:
            products = products.filter(type__id=product_type)

        return products


class ProductRetrieveView(generics.RetrieveAPIView):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]


class PaymentMethodListView(generics.ListAPIView):
    queryset = PaymentMethod.objects.all()
    serializer_class = PaymentMethodSerializer
    permission_classes = [permissions.AllowAny]


class DiscountListView(generics.ListAPIView):
    queryset = Discount.objects.filter(active=True).order_by('-create_at')
    serializer_class = DiscountSerializer
    permission_classes = [permissions.AllowAny]


class DiscountListView(generics.ListAPIView):
    queryset = Discount.objects.filter(active=True).order_by('-create_at')
    serializer_class = DiscountSerializer


class OrderCreateAPIView(views.APIView):
    permission_classes = [permissions.AllowAny]
    
    def post(self, request):
        data = {
            'user': request.user.id,
            **request.data
        }

        serializer = OrderCreateSerializer(data=data)

        if serializer.is_valid():
            instance = serializer.save()
            return Response(instance.id, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)