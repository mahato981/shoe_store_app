class CartItem {
  final int? id;
  final int shoeId;
  final String shoeName;
  final String shoeBrand;
  final String shoeImageUrl;
  final double shoePrice;
  final int size;
  final String color;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    this.id,
    required this.shoeId,
    required this.shoeName,
    required this.shoeBrand,
    required this.shoeImageUrl,
    required this.shoePrice,
    required this.size,
    required this.color,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => shoePrice * quantity;

  // Convert CartItem to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shoeId': shoeId,
      'shoeName': shoeName,
      'shoeBrand': shoeBrand,
      'shoeImageUrl': shoeImageUrl,
      'shoePrice': shoePrice,
      'size': size,
      'color': color,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Create CartItem from Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as int?,
      shoeId: map['shoeId'] as int,
      shoeName: map['shoeName'] as String,
      shoeBrand: map['shoeBrand'] as String,
      shoeImageUrl: map['shoeImageUrl'] as String,
      shoePrice: map['shoePrice'] as double,
      size: map['size'] as int,
      color: map['color'] as String,
      quantity: map['quantity'] as int,
      addedAt: DateTime.parse(map['addedAt'] as String),
    );
  }

  CartItem copyWith({
    int? id,
    int? shoeId,
    String? shoeName,
    String? shoeBrand,
    String? shoeImageUrl,
    double? shoePrice,
    int? size,
    String? color,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      shoeId: shoeId ?? this.shoeId,
      shoeName: shoeName ?? this.shoeName,
      shoeBrand: shoeBrand ?? this.shoeBrand,
      shoeImageUrl: shoeImageUrl ?? this.shoeImageUrl,
      shoePrice: shoePrice ?? this.shoePrice,
      size: size ?? this.size,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
