import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/shoe.dart';
import '../models/cart_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shoe_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Shoes table
    await db.execute('''
      CREATE TABLE shoes (
        id $idType,
        name $textType,
        brand $textType,
        category $textType,
        price $doubleType,
        description $textType,
        imageUrl $textType,
        availableSizes $textType,
        colors $textType,
        gender $textType,
        rating $doubleType,
        stock $integerType,
        createdAt $textType
      )
    ''');

    // Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        id $idType,
        shoeId $integerType,
        shoeName $textType,
        shoeBrand $textType,
        shoeImageUrl $textType,
        shoePrice $doubleType,
        size $integerType,
        color $textType,
        quantity $integerType,
        addedAt $textType
      )
    ''');

    // Create indices for better query performance
    await db.execute('CREATE INDEX idx_shoes_brand ON shoes(brand)');
    await db.execute('CREATE INDEX idx_shoes_category ON shoes(category)');
    await db.execute('CREATE INDEX idx_shoes_gender ON shoes(gender)');
    await db.execute('CREATE INDEX idx_shoes_price ON shoes(price)');
  }

  // ============ SHOE OPERATIONS ============

  Future<Shoe> insertShoe(Shoe shoe) async {
    final db = await instance.database;
    final id = await db.insert('shoes', shoe.toMap());
    return shoe.copyWith(id: id);
  }

  Future<List<Shoe>> getAllShoes() async {
    final db = await instance.database;
    final result = await db.query('shoes', orderBy: 'createdAt DESC');
    return result.map((json) => Shoe.fromMap(json)).toList();
  }

  Future<Shoe?> getShoeById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'shoes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Shoe.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Shoe>> searchShoes(String query) async {
    final db = await instance.database;
    final result = await db.query(
      'shoes',
      where: 'name LIKE ? OR brand LIKE ? OR category LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    return result.map((json) => Shoe.fromMap(json)).toList();
  }

  Future<List<Shoe>> getShoesByFilter({
    String? brand,
    String? category,
    String? gender,
    double? minPrice,
    double? maxPrice,
  }) async {
    final db = await instance.database;
    
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (brand != null && brand.isNotEmpty) {
      whereClause += ' AND brand = ?';
      whereArgs.add(brand);
    }
    if (category != null && category.isNotEmpty) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }
    if (gender != null && gender.isNotEmpty) {
      whereClause += ' AND gender = ?';
      whereArgs.add(gender);
    }
    if (minPrice != null) {
      whereClause += ' AND price >= ?';
      whereArgs.add(minPrice);
    }
    if (maxPrice != null) {
      whereClause += ' AND price <= ?';
      whereArgs.add(maxPrice);
    }

    final result = await db.query(
      'shoes',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'price ASC',
    );
    return result.map((json) => Shoe.fromMap(json)).toList();
  }

  Future<List<String>> getAllBrands() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT brand FROM shoes ORDER BY brand');
    return result.map((e) => e['brand'] as String).toList();
  }

  Future<List<String>> getAllCategories() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT DISTINCT category FROM shoes ORDER BY category');
    return result.map((e) => e['category'] as String).toList();
  }

  Future<int> updateShoe(Shoe shoe) async {
    final db = await instance.database;
    return db.update(
      'shoes',
      shoe.toMap(),
      where: 'id = ?',
      whereArgs: [shoe.id],
    );
  }

  Future<int> deleteShoe(int id) async {
    final db = await instance.database;
    return await db.delete(
      'shoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllShoes() async {
    final db = await instance.database;
    return await db.delete('shoes');
  }

  // ============ CART OPERATIONS ============

  Future<CartItem> addToCart(CartItem item) async {
    final db = await instance.database;
    
    // Check if item already exists with same shoe, size, and color
    final existing = await db.query(
      'cart_items',
      where: 'shoeId = ? AND size = ? AND color = ?',
      whereArgs: [item.shoeId, item.size, item.color],
    );

    if (existing.isNotEmpty) {
      // Update quantity
      final existingItem = CartItem.fromMap(existing.first);
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      await updateCartItem(updatedItem);
      return updatedItem;
    } else {
      // Insert new item
      final id = await db.insert('cart_items', item.toMap());
      return item.copyWith(id: id);
    }
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final result = await db.query('cart_items', orderBy: 'addedAt DESC');
    return result.map((json) => CartItem.fromMap(json)).toList();
  }

  Future<int> getCartItemCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(quantity) as total FROM cart_items');
    return result.first['total'] as int? ?? 0;
  }

  Future<double> getCartTotal() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(shoePrice * quantity) as total FROM cart_items');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> updateCartItem(CartItem item) async {
    final db = await instance.database;
    return db.update(
      'cart_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCart() async {
    final db = await instance.database;
    return await db.delete('cart_items');
  }

  // ============ IMPORT/EXPORT OPERATIONS ============

  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'shoe_store.db');
  }

  Future<bool> exportDatabase(String destinationPath) async {
    try {
      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);
      
      if (await dbFile.exists()) {
        await dbFile.copy(destinationPath);
        return true;
      }
      return false;
    } catch (e) {
      print('Error exporting database: $e');
      return false;
    }
  }

  Future<bool> importDatabase(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      
      if (!await sourceFile.exists()) {
        return false;
      }

      // Close existing database
      await close();

      // Get destination path
      final dbPath = await getDatabasePath();
      
      // Copy file
      await sourceFile.copy(dbPath);
      
      // Reopen database
      _database = await _initDB('shoe_store.db');
      
      return true;
    } catch (e) {
      print('Error importing database: $e');
      return false;
    }
  }

  Future<int> getShoeCount() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM shoes');
    return result.first['count'] as int? ?? 0;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
