from django.contrib import admin
from django import forms

from .models import (
    ProductType,
    Product,
    PaymentMethod,
    Discount,
    Order,
    OrderDetail
)

# Register your models here.
class ProductTypeForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['parent'].required = False

    class Meta:
        model = ProductType
        fields = '__all__'

class ProductTypeAdmin(admin.ModelAdmin):
    list_display = ('code', 'parent', 'desc',)
    form = ProductTypeForm

admin.site.register(ProductType, ProductTypeAdmin)
admin.site.register(Product)
admin.site.register(PaymentMethod)
admin.site.register(Discount)
admin.site.register(Order)
admin.site.register(OrderDetail)