import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  print('Creating sample database...');
  
  // Create database in current directory
  final dbPath = join(Directory.current.path, 'shoe_store_sample.db');
  
  // Delete if exists
  if (await File(dbPath).exists()) {
    await File(dbPath).delete();
  }
  
  // Create database
  final database = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      // Create shoes table
      await db.execute('''
        CREATE TABLE shoes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          brand TEXT NOT NULL,
          category TEXT NOT NULL,
          price REAL NOT NULL,
          description TEXT NOT NULL,
          imageUrl TEXT NOT NULL,
          availableSizes TEXT NOT NULL,
          colors TEXT NOT NULL,
          gender TEXT NOT NULL,
          rating REAL NOT NULL,
          stock INTEGER NOT NULL,
          createdAt TEXT NOT NULL
        )
      ''');

      // Create cart items table
      await db.execute('''
        CREATE TABLE cart_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          shoeId INTEGER NOT NULL,
          shoeName TEXT NOT NULL,
          shoeBrand TEXT NOT NULL,
          shoeImageUrl TEXT NOT NULL,
          shoePrice REAL NOT NULL,
          size INTEGER NOT NULL,
          color TEXT NOT NULL,
          quantity INTEGER NOT NULL,
          addedAt TEXT NOT NULL
        )
      ''');

      // Create indices
      await db.execute('CREATE INDEX idx_shoes_brand ON shoes(brand)');
      await db.execute('CREATE INDEX idx_shoes_category ON shoes(category)');
      await db.execute('CREATE INDEX idx_shoes_gender ON shoes(gender)');
      await db.execute('CREATE INDEX idx_shoes_price ON shoes(price)');

      print('Tables created successfully');
    },
  );

  // Insert sample data
  final sampleShoes = [
    {
      'name': 'Nike Air Max 270',
      'brand': 'Nike',
      'category': 'Running',
      'price': 12995.0,
      'description': 'The Nike Air Max 270 delivers visible cushioning under every step. With its sleek design and comfortable fit, it\'s perfect for all-day wear.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/awjogtdnqxniqqk0wpgf/air-max-270-shoes-2V5C4p.png',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'Black,White,Blue,Red',
      'gender': 'Men',
      'rating': 4.5,
      'stock': 50,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike Revolution 6',
      'brand': 'Nike',
      'category': 'Running',
      'price': 3495.0,
      'description': 'A lightweight and breathable running shoe with excellent cushioning. Perfect for your daily runs and workouts.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/7c95d410-f4e2-4f1a-b9f6-84bf1c479bb2/revolution-6-nn-road-running-shoes-3fZn6J.png',
      'availableSizes': '6,7,8,9,10,11',
      'colors': 'Black,Grey,Blue',
      'gender': 'Men',
      'rating': 4.2,
      'stock': 75,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike React Infinity Run',
      'brand': 'Nike',
      'category': 'Running',
      'price': 13995.0,
      'description': 'Designed to help reduce injury and keep you running. The Nike React Infinity Run continues to help you chase your goals.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/i1-8d7bd95d-d99e-4345-9a89-3a677ae0a40c/react-infinity-3-road-running-shoes-TqkPQz.png',
      'availableSizes': '7,8,9,10,11,12',
      'colors': 'White,Black,Pink,Blue',
      'gender': 'Women',
      'rating': 4.7,
      'stock': 40,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike Air Force 1',
      'brand': 'Nike',
      'category': 'Casual',
      'price': 8695.0,
      'description': 'The icon that changed sneaker history. Classic style meets modern comfort in this legendary basketball shoe.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/air-force-1-07-shoes-WrLlWX.png',
      'availableSizes': '6,7,8,9,10,11,12,13',
      'colors': 'White,Black,Red',
      'gender': 'Unisex',
      'rating': 4.8,
      'stock': 100,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Adidas Ultraboost 22',
      'brand': 'Adidas',
      'category': 'Running',
      'price': 17995.0,
      'description': 'The ultimate running shoe with responsive Boost cushioning. Engineered for comfort and performance.',
      'imageUrl': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/fbaf991a78bc4896a3e9ad7800abcec6_9366/Ultraboost_22_Shoes_Black_GZ0127_01_standard.jpg',
      'availableSizes': '7,8,9,10,11,12',
      'colors': 'Black,White,Blue,Grey',
      'gender': 'Men',
      'rating': 4.6,
      'stock': 60,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Adidas Superstar',
      'brand': 'Adidas',
      'category': 'Casual',
      'price': 7999.0,
      'description': 'An iconic shoe with a rich heritage. The shell toe design has been a street style staple for decades.',
      'imageUrl': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/12365dbc7c424288b7fdabc500fd146e_9366/Superstar_Shoes_White_EG4958_01_standard.jpg',
      'availableSizes': '6,7,8,9,10,11',
      'colors': 'White,Black,Red',
      'gender': 'Unisex',
      'rating': 4.7,
      'stock': 80,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Adidas Stan Smith',
      'brand': 'Adidas',
      'category': 'Casual',
      'price': 8499.0,
      'description': 'Clean, classic tennis style. This versatile shoe pairs with everything in your closet.',
      'imageUrl': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0c9a889b13d042df8d49aae700d27efb_9366/Stan_Smith_Shoes_White_M20324_01_standard.jpg',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'White,Green',
      'gender': 'Unisex',
      'rating': 4.5,
      'stock': 90,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Puma RS-X',
      'brand': 'Puma',
      'category': 'Casual',
      'price': 9999.0,
      'description': 'Bold, chunky sneaker design inspired by the evolution of technology. Make a statement with every step.',
      'imageUrl': 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/380462/01/sv01/fnd/IND/fmt/png/RS-X-Toys-Sneakers',
      'availableSizes': '7,8,9,10,11',
      'colors': 'White,Black,Multi',
      'gender': 'Men',
      'rating': 4.3,
      'stock': 45,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Puma Suede Classic',
      'brand': 'Puma',
      'category': 'Casual',
      'price': 5499.0,
      'description': 'A timeless icon. The soft suede upper and classic design make this a must-have.',
      'imageUrl': 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/374915/01/sv01/fnd/IND/fmt/png/Suede-Classic-XXI-Sneakers',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'Black,Blue,Red,Grey',
      'gender': 'Unisex',
      'rating': 4.4,
      'stock': 70,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Reebok Classic Leather',
      'brand': 'Reebok',
      'category': 'Casual',
      'price': 6999.0,
      'description': 'Simple and clean design that goes with everything. Soft leather upper for premium comfort.',
      'imageUrl': 'https://assets.reebok.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8331c7c6b8d947f7a661ac1500d7d13e_9366/Classic_Leather_Shoes_White_49799_01_standard.jpg',
      'availableSizes': '7,8,9,10,11,12',
      'colors': 'White,Black',
      'gender': 'Unisex',
      'rating': 4.3,
      'stock': 55,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Reebok Nano X2',
      'brand': 'Reebok',
      'category': 'Training',
      'price': 12999.0,
      'description': 'Built for intense training sessions. Stable platform for lifting and flexible for agility work.',
      'imageUrl': 'https://assets.reebok.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4c64d5f0d8f14b8da9a6acfd00f28b8a_9366/Nano_X2_Shoes_Black_GV9289_01_standard.jpg',
      'availableSizes': '7,8,9,10,11',
      'colors': 'Black,Grey,Blue',
      'gender': 'Men',
      'rating': 4.5,
      'stock': 35,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'New Balance 574',
      'brand': 'New Balance',
      'category': 'Casual',
      'price': 7499.0,
      'description': 'The iconic 574 brings classic style with modern comfort. A perfect everyday shoe.',
      'imageUrl': 'https://nb.scene7.com/is/image/NB/ml574evg_nb_02_i?\$dw_detail_main_lg\$&bgc=f5f5f5&layer=1&bgcolor=f5f5f5&blendMode=mult&scale=10&wid=1600&hei=1600',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'Grey,Navy,Black,Green',
      'gender': 'Unisex',
      'rating': 4.4,
      'stock': 65,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'New Balance 990v5',
      'brand': 'New Balance',
      'category': 'Running',
      'price': 17500.0,
      'description': 'Premium running shoe with superior cushioning and support. Made in USA.',
      'imageUrl': 'https://nb.scene7.com/is/image/NB/m990gl5_nb_02_i?\$dw_detail_main_lg\$&bgc=f5f5f5&layer=1&bgcolor=f5f5f5&blendMode=mult&scale=10&wid=1600&hei=1600',
      'availableSizes': '7,8,9,10,11,12',
      'colors': 'Grey,Navy',
      'gender': 'Men',
      'rating': 4.8,
      'stock': 30,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Converse Chuck Taylor All Star',
      'brand': 'Converse',
      'category': 'Casual',
      'price': 3999.0,
      'description': 'The original basketball shoe turned cultural icon. A timeless classic for any wardrobe.',
      'imageUrl': 'https://www.converse.in/media/catalog/product/M/9/M9160C_1.jpg',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'Black,White,Red,Blue',
      'gender': 'Unisex',
      'rating': 4.6,
      'stock': 120,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Converse Chuck 70',
      'brand': 'Converse',
      'category': 'Casual',
      'price': 6499.0,
      'description': 'Premium version of the classic Chuck with enhanced cushioning and vintage details.',
      'imageUrl': 'https://www.converse.in/media/catalog/product/1/6/162050C_1.jpg',
      'availableSizes': '6,7,8,9,10,11',
      'colors': 'Black,White,Parchment',
      'gender': 'Unisex',
      'rating': 4.7,
      'stock': 85,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Vans Old Skool',
      'brand': 'Vans',
      'category': 'Casual',
      'price': 4999.0,
      'description': 'The classic skate shoe with the iconic side stripe. Durable canvas and suede construction.',
      'imageUrl': 'https://images.vans.com/is/image/Vans/VN000D3HY28-HERO?wid=1600&hei=1984&fmt=jpeg&qlt=90&resMode=sharp2&op_usm=0.9,1.7,8,0',
      'availableSizes': '6,7,8,9,10,11,12',
      'colors': 'Black,White,Navy,Red',
      'gender': 'Unisex',
      'rating': 4.5,
      'stock': 95,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Vans Authentic',
      'brand': 'Vans',
      'category': 'Casual',
      'price': 4299.0,
      'description': 'Simple, low-top lace-up with sturdy canvas upper. The original classic since 1966.',
      'imageUrl': 'https://images.vans.com/is/image/Vans/EE3BLK-HERO?wid=1600&hei=1984&fmt=jpeg&qlt=90&resMode=sharp2&op_usm=0.9,1.7,8,0',
      'availableSizes': '6,7,8,9,10,11',
      'colors': 'Black,White,Navy',
      'gender': 'Unisex',
      'rating': 4.4,
      'stock': 100,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike Air Zoom Pegasus 39',
      'brand': 'Nike',
      'category': 'Running',
      'price': 10995.0,
      'description': 'Responsive cushioning and smooth ride for runners. Built for comfort on every run.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/88d9ff5e-4f6a-41f4-92f1-d4e88f5e0b46/air-zoom-pegasus-39-road-running-shoes-FKQ4fM.png',
      'availableSizes': '5,6,7,8,9,10',
      'colors': 'Pink,White,Black,Purple',
      'gender': 'Women',
      'rating': 4.6,
      'stock': 55,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Adidas NMD R1',
      'brand': 'Adidas',
      'category': 'Casual',
      'price': 12999.0,
      'description': 'Modern street style with innovative Boost cushioning. Comfort meets fashion.',
      'imageUrl': 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a69e58ed40f444b4b6d7ab3c00a8d6b4_9366/NMD_R1_Shoes_White_GZ7922_01_standard.jpg',
      'availableSizes': '5,6,7,8,9,10',
      'colors': 'White,Black,Pink',
      'gender': 'Women',
      'rating': 4.5,
      'stock': 50,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike Mercurial Superfly',
      'brand': 'Nike',
      'category': 'Football',
      'price': 24995.0,
      'description': 'Elite football boots for speed and precision. Built for the world\'s fastest players.',
      'imageUrl': 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/e67fd5c7-5b28-48c1-a64a-6c542a7cfa49/mercurial-superfly-9-elite-fg-football-boot-LqWGGG.png',
      'availableSizes': '7,8,9,10,11,12',
      'colors': 'Black,White,Red',
      'gender': 'Men',
      'rating': 4.8,
      'stock': 25,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  final batch = database.batch();
  for (final shoe in sampleShoes) {
    batch.insert('shoes', shoe);
  }
  await batch.commit(noResult: true);

  print('Inserted ${sampleShoes.length} sample shoes');
  
  await database.close();
  
  print('\nDatabase created successfully!');
  print('Location: $dbPath');
  print('\nYou can now:');
  print('1. Edit this database using SQLite Browser or similar tools');
  print('2. Import it into the app using the Admin panel');
  print('3. Or copy it to: shoe_store_app/assets/sample_db/');
}
