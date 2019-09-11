// To parse this JSON data, do
//
//     final item = itemFromJson(jsonString);

import 'dart:convert';

Item itemFromJson(String str) => Item.fromMap(json.decode(str));

String itemToJson(Item data) => json.encode(data.toMap());

class Item {
  String title;
  String description;
  String price;
 // List<dynamic> colors;
  String category;
  String image;

  Item({
    this.title,
    this.description,
    this.price,
  //  this.colors,
    this.category,
    this.image,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
    title: json["title"],
    description: json["description"],
    price: json["price"],
 //   colors: List<dynamic>.from(json["colors"].map((x) => x)),
    category: json["category"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "title": title ?? "",
    "description": description ?? "",
    "price": price ?? "",
   // "colors": List<dynamic>.from(colors.map((x) => x)) ?? "",
    "category": category ?? "",
    "image": image ?? "",
  };
}
