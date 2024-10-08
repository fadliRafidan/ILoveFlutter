class Product {
  final String productId;
  final String name;
  final String description;
  final num price;
  final String categoryId;
  final DateTime createdAt;
  final String imageUrl;
  // ignore: non_constant_identifier_names
  bool is_favorit;
  final Category category;

  Product({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.createdAt,
    required this.imageUrl,
    // ignore: non_constant_identifier_names
    this.is_favorit = false,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : map['price'].toDouble(),
      categoryId: map['categori_id'],
      createdAt: DateTime.parse(map['created_at']),
      imageUrl: map['image'],
      is_favorit: map['is_favorit'],
      category: Category.fromMap(
          map['categories']), 
    );
  }
}

class Category {
  final String name;
  final String categoryId;
  final DateTime createdAt;

  Category({
    required this.name,
    required this.categoryId,
    required this.createdAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'],
      categoryId: map['categori_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
