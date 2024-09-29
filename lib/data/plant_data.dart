class Plants {
  final String productId;
  final String name;
  final String image;
  final double price;
  // Add other necessary fields

  Plants({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
  });

  // Factory constructor to create a Plants instance from a Map
  factory Plants.fromMap(Map<String, dynamic> data) {
    return Plants(
      productId: data['product_id'],
      name: data['name'],
      image: data['image'],
      price: data['price'].toDouble(), // Ensure price is double
    );
  }
}
