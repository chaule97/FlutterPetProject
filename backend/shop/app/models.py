from django.db import models
from django.conf import settings
import uuid
from os.path import splitext

# Create your models here.
class ProductType(models.Model):
    code = models.IntegerField(unique=True, primary_key=True)
    parent = models.ForeignKey('self', null=True, on_delete=models.CASCADE)
    desc = models.TextField()

    def __str__(self):
        return f'{self.code} {self.desc}'


def get_filename(_, filename):
    _, extension = splitext(filename)
    return f'{uuid.uuid4().hex}{extension}'


class Product(models.Model):
    name = models.CharField(max_length=30)
    avatar = models.ImageField(upload_to=get_filename, null=True)
    desc = models.TextField()
    type = models.ForeignKey(ProductType, on_delete=models.CASCADE)
    sku = models.CharField(max_length=30)
    price = models.FloatField()
    create_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.id} {self.name}'

    def save(self, *args, **kwargs):
        try:
            this = Product.objects.get(id=self.id)
            if this.avatar.name != self.avatar.name:
                this.avatar.delete(save=False)
        except Product.DoesNotExist:
            pass
        super(Product, self).save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        self.avatar.delete(save=False)
        super(Product, self).delete(*args, **kwargs)


class PaymentMethod(models.Model):
    code = models.IntegerField(unique=True, primary_key=True)
    desc = models.TextField()


class Discount(models.Model):
    name = models.CharField(max_length=30)
    desc = models.TextField()
    discount_percent = models.FloatField()
    active = models.BooleanField(default=True)
    create_at = models.DateTimeField(auto_now_add=True)


class Order(models.Model):
    ORDER_STATUS_CODE = (
        ('Pending', 'Pending'),
        ('Confirm', 'Confirm'),
        ('Trasport', 'Trasport'),
        ('Done', 'Done'),
    )

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    order_status_code = models.CharField(max_length=30, choices=ORDER_STATUS_CODE)
    discount = models.ForeignKey(Discount, null=True, on_delete=models.DO_NOTHING)


class OrderDetail(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.DO_NOTHING)
    quantity = models.IntegerField()
    price = models.FloatField()