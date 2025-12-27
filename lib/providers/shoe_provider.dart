import 'package:flutter/foundation.dart';
import '../models/shoe.dart';
import '../database/database_helper.dart';

class ShoeProvider with ChangeNotifier {
  List<Shoe> _shoes = [];
  List<Shoe> _filteredShoes = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedBrand;
  String? _selectedCategory;
  String? _selectedGender;
  double? _minPrice;
  double? _maxPrice;

  List<Shoe> get shoes => _filteredShoes.isEmpty && _searchQuery.isEmpty && _selectedBrand == null && _selectedCategory == null && _selectedGender == null ? _shoes : _filteredShoes;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get selectedBrand => _selectedBrand;
  String? get selectedCategory => _selectedCategory;
  String? get selectedGender => _selectedGender;

  Future<void> loadShoes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _shoes = await DatabaseHelper.instance.getAllShoes();
      _filteredShoes = _shoes;
    } catch (e) {
      print('Error loading shoes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchShoes(String query) async {
    _searchQuery = query;
    
    if (query.isEmpty) {
      await applyFilters();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _filteredShoes = await DatabaseHelper.instance.searchShoes(query);
    } catch (e) {
      print('Error searching shoes: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> applyFilters() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_selectedBrand == null && _selectedCategory == null && _selectedGender == null && _minPrice == null && _maxPrice == null) {
        _filteredShoes = _shoes;
      } else {
        _filteredShoes = await DatabaseHelper.instance.getShoesByFilter(
          brand: _selectedBrand,
          category: _selectedCategory,
          gender: _selectedGender,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
        );
      }
    } catch (e) {
      print('Error applying filters: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilters({
    String? brand,
    String? category,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) {
    _selectedBrand = brand;
    _selectedCategory = category;
    _selectedGender = gender;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    applyFilters();
  }

  void clearFilters() {
    _selectedBrand = null;
    _selectedCategory = null;
    _selectedGender = null;
    _minPrice = null;
    _maxPrice = null;
    _searchQuery = '';
    _filteredShoes = _shoes;
    notifyListeners();
  }

  Future<List<String>> getBrands() async {
    return await DatabaseHelper.instance.getAllBrands();
  }

  Future<List<String>> getCategories() async {
    return await DatabaseHelper.instance.getAllCategories();
  }

  Future<Shoe?> getShoeById(int id) async {
    return await DatabaseHelper.instance.getShoeById(id);
  }

  Future<int> getShoeCount() async {
    return await DatabaseHelper.instance.getShoeCount();
  }
}
