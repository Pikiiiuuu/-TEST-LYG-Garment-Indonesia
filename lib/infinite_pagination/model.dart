import 'dart:convert';
import 'dart:ffi';

class ResponseModel {
  ResponseModel({
    required this.products,
  });

  final List<Product> products;

  factory ResponseModel.fromJson(String str) =>
      ResponseModel.fromMap(json.decode(str));

  factory ResponseModel.fromMap(Map<String, dynamic> json) => ResponseModel(
    products: List<Product>.from(json["products"].map((x) => Product.fromMap(x))),
  );
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  final int id;
  final String title;
  final String description;
  final int price;
  final double discountPercentage;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;
  final List images;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    discountPercentage: json["discountPercentage"],
    stock: json["stock"],
    brand: json["brand"],
    category: json["category"],
    thumbnail: json["thumbnail"],
    images: json['images'],
  );
}

