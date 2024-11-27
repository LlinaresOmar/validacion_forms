import 'dart:convert';

class Product {
    bool available;
    String name;
    String? picture;
    double price;
    String? id;

    Product({
        required this.available,
        required this.name,
        this.picture,
        required this.price,
        this.id
    });

    factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
    };

    factory Product.fromMap(Map<String, dynamic> map) => Product(
      available: map["available"] ?? false,
      name: map["name"] ?? '',
      picture: map["picture"],
      price: map["price"] != null ? map["price"].toDouble() : 0.0,
      id: map["id"],
    );

    Product copy() => Product(
      available: this.available,
      picture: this.picture,
      name: this.name, 
      price: this.price,
      id: this.id
    );
}
