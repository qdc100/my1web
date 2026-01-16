from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Topic(models.Model):
    text=models.CharField(max_length=200,unique=True)
    date_added=models.DateTimeField(auto_now_add=True)
    owner=models.ForeignKey(User,on_delete=models.CASCADE)

    def __str__(self):
        return self.text
    
class Entry(models.Model):
    topic=models.ForeignKey(Topic,on_delete=models.CASCADE)
    text=models.CharField(max_length=1000)
    date_added=models.DateTimeField(auto_now_add=True)
    image=models.ImageField(upload_to='entry_images/', blank=True, null=True)

    class Meta:
        verbose_name_plural='entries'

    def __str__(self):
        return f"{self.text[:50]}..."