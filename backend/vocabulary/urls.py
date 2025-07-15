from django.urls import include, path
from . import views

urlpatterns = [
    path('generate_sentences/', views.generate_sentences, name='generate_sentences'),
]