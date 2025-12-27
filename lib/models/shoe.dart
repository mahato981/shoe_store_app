class Shoe {
  final int? id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final List<int> availableSizes;
  final List<String> colors;
  final String gender; // Men, Women, Unisex
  final double rating;
  final int stock;
  final DateTime createdAt;

  Shoe({
    this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.availableSizes,
    required this.colors,
    required this.gender,
    this.rating = 0.0,
    this.stock = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert Shoe to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'availableSizes': availableSizes.join(','),
      'colors': colors.join(','),
      'gender': gender,
      'rating': rating,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Shoe from Map
  factory Shoe.fromMap(Map<String, dynamic> map) {
    return Shoe(
      id: map['id'] as int?,
      name: map['name'] as String,
      brand: map['brand'] as String,
      category: map['category'] as String,
      price: map['price'] as double,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      availableSizes: (map['availableSizes'] as String)
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList(),
      colors: (map['colors'] as String).split(',').map((e) => e.trim()).toList(),
      gender: map['gender'] as String,
      rating: map['rating'] as double,
      stock: map['stock'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Shoe copyWith({
    int? id,
    String? name,
    String? brand,
    String? category,
    double? price,
    String? description,
    String? imageUrl,
    List<int>? availableSizes,
    List<String>? colors,
    String? gender,
    double? rating,
    int? stock,
    DateTime? createdAt,
  }) {
    return Shoe(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      availableSizes: availableSizes ?? this.availableSizes,
      colors: colors ?? this.colors,
      gender: gender ?? this.gender,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
