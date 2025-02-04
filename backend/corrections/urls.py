from django.urls import include, path
from . import views

urlpatterns = [
    path('correction/', views.correction_view, name='correction_view'),
]