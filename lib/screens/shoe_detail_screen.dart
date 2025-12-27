import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/shoe.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class ShoeDetailScreen extends StatefulWidget {
  final Shoe shoe;

  const ShoeDetailScreen({Key? key, required this.shoe}) : super(key: key);

  @override
  State<ShoeDetailScreen> createState() => _ShoeDetailScreenState();
}

class _ShoeDetailScreenState extends State<ShoeDetailScreen> {
  int? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    if (widget.shoe.availableSizes.isNotEmpty) {
      _selectedSize = widget.shoe.availableSizes[0];
    }
    if (widget.shoe.colors.isNotEmpty) {
      _selectedColor = widget.shoe.colors[0];
    }
  }

  void _addToCart() {
    if (_selectedSize == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select size and color'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cartItem = CartItem(
      shoeId: widget.shoe.id!,
      shoeName: widget.shoe.name,
      shoeBrand: widget.shoe.brand,
      shoeImageUrl: widget.shoe.imageUrl,
      shoePrice: widget.shoe.price,
      size: _selectedSize!,
      color: _selectedColor!,
      quantity: _quantity,
    );

    context.read<CartProvider>().addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoe Details'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shoe Image
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[100],
              child: widget.shoe.imageUrl.startsWith('http')
                  ? Image.network(
                      widget.shoe.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    )
                  : _buildPlaceholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    widget.shoe.brand,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Name
                  Text(
                    widget.shoe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currencyFormatter.format(widget.shoe.price),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (widget.shoe.rating > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[700],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.shoe.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category and Gender
                  Row(
                    children: [
                      Chip(
                        label: Text(widget.shoe.category),
                        backgroundColor: Colors.blue[50],
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(widget.shoe.gender),
                        backgroundColor: Colors.purple[50],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stock Status
                  if (widget.shoe.stock > 0)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'In Stock (${widget.shoe.stock} available)',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cancel, color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Select Size
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.shoe.availableSizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return ChoiceChip(
                        label: Text('UK $size'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedSize = size;
                          });
                        },
                        selectedColor: Colors.blue[700],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Select Color
                  const Text(
                    'Select Color',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.shoe.colors.map((color) {
                      final isSelected = _selectedColor == color;
                      return ChoiceChip(
                        label: Text(color),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        selectedColor: Colors.blue[700],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 32,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _quantity.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _quantity < widget.shoe.stock
                            ? () {
                                setState(() {
                                  _quantity++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.shoe.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: widget.shoe.stock > 0 ? _addToCart : null,
              icon: const Icon(Icons.shopping_cart),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 100,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
