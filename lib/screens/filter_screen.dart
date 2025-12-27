import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shoe_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedBrand;
  String? _selectedCategory;
  String? _selectedGender;
  double _minPrice = 0;
  double _maxPrice = 20000;
  
  List<String> _brands = [];
  List<String> _categories = [];
  final List<String> _genders = ['Men', 'Women', 'Unisex'];

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
    
    final shoeProvider = context.read<ShoeProvider>();
    _selectedBrand = shoeProvider.selectedBrand;
    _selectedCategory = shoeProvider.selectedCategory;
    _selectedGender = shoeProvider.selectedGender;
  }

  Future<void> _loadFilterOptions() async {
    final shoeProvider = context.read<ShoeProvider>();
    final brands = await shoeProvider.getBrands();
    final categories = await shoeProvider.getCategories();
    
    setState(() {
      _brands = brands;
      _categories = categories;
    });
  }

  void _applyFilters() {
    context.read<ShoeProvider>().setFilters(
      brand: _selectedBrand,
      category: _selectedCategory,
      gender: _selectedGender,
      minPrice: _minPrice > 0 ? _minPrice : null,
      maxPrice: _maxPrice < 20000 ? _maxPrice : null,
    );
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedBrand = null;
      _selectedCategory = null;
      _selectedGender = null;
      _minPrice = 0;
      _maxPrice = 20000;
    });
    context.read<ShoeProvider>().clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Brand Filter
          const Text(
            'Brand',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_brands.isEmpty)
            const Text('No brands available')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedBrand == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedBrand = null;
                    });
                  },
                ),
                ..._brands.map((brand) {
                  return ChoiceChip(
                    label: Text(brand),
                    selected: _selectedBrand == brand,
                    onSelected: (selected) {
                      setState(() {
                        _selectedBrand = selected ? brand : null;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          const SizedBox(height: 24),

          // Category Filter
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (_categories.isEmpty)
            const Text('No categories available')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                ..._categories.map((category) {
                  return ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          const SizedBox(height: 24),

          // Gender Filter
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedGender == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedGender = null;
                  });
                },
              ),
              ..._genders.map((gender) {
                return ChoiceChip(
                  label: Text(gender),
                  selected: _selectedGender == gender,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGender = selected ? gender : null;
                    });
                  },
                );
              }).toList(),
            ],
          ),
          const SizedBox(height: 24),

          // Price Range Filter
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${_minPrice.toInt()}'),
              Text('₹${_maxPrice.toInt()}'),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 20000,
            divisions: 40,
            labels: RangeLabels(
              '₹${_minPrice.toInt()}',
              '₹${_maxPrice.toInt()}',
            ),
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
        ],
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
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
