
import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
    bool success;
    String message;
    List<ProductDatum> data;

    Product({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        success: json["success"],
        message: json["message"],
        data: List<ProductDatum>.from(json["data"].map((x) => ProductDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ProductDatum {
    int id;
    String name;
    String description;
    int price;
    DateTime createdAt;
    DateTime updatedAt;

    ProductDatum({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ProductDatum.fromJson(Map<String, dynamic> json) => ProductDatum(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}