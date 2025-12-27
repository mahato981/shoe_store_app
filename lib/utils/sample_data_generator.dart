import '../models/shoe.dart';
import '../database/database_helper.dart';

class SampleDataGenerator {
  static Future<void> generateSampleData() async {
    final db = DatabaseHelper.instance;
    
    // Check if data already exists
    final count = await db.getShoeCount();
    if (count > 0) {
      return; // Don't generate if data already exists
    }

    final sampleShoes = [
      // Nike Shoes
      Shoe(
        name: 'Nike Air Max 270',
        brand: 'Nike',
        category: 'Running',
        price: 12995,
        description: 'The Nike Air Max 270 delivers visible cushioning under every step. With its sleek design and comfortable fit, it\'s perfect for all-day wear.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/awjogtdnqxniqqk0wpgf/air-max-270-shoes-2V5C4p.png',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['Black', 'White', 'Blue', 'Red'],
        gender: 'Men',
        rating: 4.5,
        stock: 50,
      ),
      Shoe(
        name: 'Nike Revolution 6',
        brand: 'Nike',
        category: 'Running',
        price: 3495,
        description: 'A lightweight and breathable running shoe with excellent cushioning. Perfect for your daily runs and workouts.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/7c95d410-f4e2-4f1a-b9f6-84bf1c479bb2/revolution-6-nn-road-running-shoes-3fZn6J.png',
        availableSizes: [6, 7, 8, 9, 10, 11],
        colors: ['Black', 'Grey', 'Blue'],
        gender: 'Men',
        rating: 4.2,
        stock: 75,
      ),
      Shoe(
        name: 'Nike React Infinity Run',
        brand: 'Nike',
        category: 'Running',
        price: 13995,
        description: 'Designed to help reduce injury and keep you running. The Nike React Infinity Run continues to help you chase your goals.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/i1-8d7bd95d-d99e-4345-9a89-3a677ae0a40c/react-infinity-3-road-running-shoes-TqkPQz.png',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['White', 'Black', 'Pink', 'Blue'],
        gender: 'Women',
        rating: 4.7,
        stock: 40,
      ),
      Shoe(
        name: 'Nike Air Force 1',
        brand: 'Nike',
        category: 'Casual',
        price: 8695,
        description: 'The icon that changed sneaker history. Classic style meets modern comfort in this legendary basketball shoe.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/air-force-1-07-shoes-WrLlWX.png',
        availableSizes: [6, 7, 8, 9, 10, 11, 12, 13],
        colors: ['White', 'Black', 'Red'],
        gender: 'Unisex',
        rating: 4.8,
        stock: 100,
      ),

      // Adidas Shoes
      Shoe(
        name: 'Adidas Ultraboost 22',
        brand: 'Adidas',
        category: 'Running',
        price: 17995,
        description: 'The ultimate running shoe with responsive Boost cushioning. Engineered for comfort and performance.',
        imageUrl: 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/fbaf991a78bc4896a3e9ad7800abcec6_9366/Ultraboost_22_Shoes_Black_GZ0127_01_standard.jpg',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['Black', 'White', 'Blue', 'Grey'],
        gender: 'Men',
        rating: 4.6,
        stock: 60,
      ),
      Shoe(
        name: 'Adidas Superstar',
        brand: 'Adidas',
        category: 'Casual',
        price: 7999,
        description: 'An iconic shoe with a rich heritage. The shell toe design has been a street style staple for decades.',
        imageUrl: 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/12365dbc7c424288b7fdabc500fd146e_9366/Superstar_Shoes_White_EG4958_01_standard.jpg',
        availableSizes: [6, 7, 8, 9, 10, 11],
        colors: ['White', 'Black', 'Red'],
        gender: 'Unisex',
        rating: 4.7,
        stock: 80,
      ),
      Shoe(
        name: 'Adidas Stan Smith',
        brand: 'Adidas',
        category: 'Casual',
        price: 8499,
        description: 'Clean, classic tennis style. This versatile shoe pairs with everything in your closet.',
        imageUrl: 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/0c9a889b13d042df8d49aae700d27efb_9366/Stan_Smith_Shoes_White_M20324_01_standard.jpg',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['White', 'Green'],
        gender: 'Unisex',
        rating: 4.5,
        stock: 90,
      ),

      // Puma Shoes
      Shoe(
        name: 'Puma RS-X',
        brand: 'Puma',
        category: 'Casual',
        price: 9999,
        description: 'Bold, chunky sneaker design inspired by the evolution of technology. Make a statement with every step.',
        imageUrl: 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/380462/01/sv01/fnd/IND/fmt/png/RS-X-Toys-Sneakers',
        availableSizes: [7, 8, 9, 10, 11],
        colors: ['White', 'Black', 'Multi'],
        gender: 'Men',
        rating: 4.3,
        stock: 45,
      ),
      Shoe(
        name: 'Puma Suede Classic',
        brand: 'Puma',
        category: 'Casual',
        price: 5499,
        description: 'A timeless icon. The soft suede upper and classic design make this a must-have.',
        imageUrl: 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/374915/01/sv01/fnd/IND/fmt/png/Suede-Classic-XXI-Sneakers',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['Black', 'Blue', 'Red', 'Grey'],
        gender: 'Unisex',
        rating: 4.4,
        stock: 70,
      ),

      // Reebok Shoes
      Shoe(
        name: 'Reebok Classic Leather',
        brand: 'Reebok',
        category: 'Casual',
        price: 6999,
        description: 'Simple and clean design that goes with everything. Soft leather upper for premium comfort.',
        imageUrl: 'https://assets.reebok.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/8331c7c6b8d947f7a661ac1500d7d13e_9366/Classic_Leather_Shoes_White_49799_01_standard.jpg',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['White', 'Black'],
        gender: 'Unisex',
        rating: 4.3,
        stock: 55,
      ),
      Shoe(
        name: 'Reebok Nano X2',
        brand: 'Reebok',
        category: 'Training',
        price: 12999,
        description: 'Built for intense training sessions. Stable platform for lifting and flexible for agility work.',
        imageUrl: 'https://assets.reebok.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4c64d5f0d8f14b8da9a6acfd00f28b8a_9366/Nano_X2_Shoes_Black_GV9289_01_standard.jpg',
        availableSizes: [7, 8, 9, 10, 11],
        colors: ['Black', 'Grey', 'Blue'],
        gender: 'Men',
        rating: 4.5,
        stock: 35,
      ),

      // New Balance Shoes
      Shoe(
        name: 'New Balance 574',
        brand: 'New Balance',
        category: 'Casual',
        price: 7499,
        description: 'The iconic 574 brings classic style with modern comfort. A perfect everyday shoe.',
        imageUrl: 'https://nb.scene7.com/is/image/NB/ml574evg_nb_02_i',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['Grey', 'Navy', 'Black', 'Green'],
        gender: 'Unisex',
        rating: 4.4,
        stock: 65,
      ),
      Shoe(
        name: 'New Balance 990v5',
        brand: 'New Balance',
        category: 'Running',
        price: 17500,
        description: 'Premium running shoe with superior cushioning and support. Made in USA.',
        imageUrl: 'https://nb.scene7.com/is/image/NB/m990gl5_nb_02_i',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['Grey', 'Navy'],
        gender: 'Men',
        rating: 4.8,
        stock: 30,
      ),

      // Converse Shoes
      Shoe(
        name: 'Converse Chuck Taylor All Star',
        brand: 'Converse',
        category: 'Casual',
        price: 3999,
        description: 'The original basketball shoe turned cultural icon. A timeless classic for any wardrobe.',
        imageUrl: 'https://www.converse.in/media/catalog/product/M/9/M9160C_1.jpg',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['Black', 'White', 'Red', 'Blue'],
        gender: 'Unisex',
        rating: 4.6,
        stock: 120,
      ),
      Shoe(
        name: 'Converse Chuck 70',
        brand: 'Converse',
        category: 'Casual',
        price: 6499,
        description: 'Premium version of the classic Chuck with enhanced cushioning and vintage details.',
        imageUrl: 'https://www.converse.in/media/catalog/product/1/6/162050C_1.jpg',
        availableSizes: [6, 7, 8, 9, 10, 11],
        colors: ['Black', 'White', 'Parchment'],
        gender: 'Unisex',
        rating: 4.7,
        stock: 85,
      ),

      // Vans Shoes
      Shoe(
        name: 'Vans Old Skool',
        brand: 'Vans',
        category: 'Casual',
        price: 4999,
        description: 'The classic skate shoe with the iconic side stripe. Durable canvas and suede construction.',
        imageUrl: 'https://images.vans.com/is/image/Vans/VN000D3HY28-HERO?wid=1600&hei=1984&fmt=jpeg&qlt=90&resMode=sharp2&op_usm=0.9,1.7,8,0',
        availableSizes: [6, 7, 8, 9, 10, 11, 12],
        colors: ['Black', 'White', 'Navy', 'Red'],
        gender: 'Unisex',
        rating: 4.5,
        stock: 95,
      ),
      Shoe(
        name: 'Vans Authentic',
        brand: 'Vans',
        category: 'Casual',
        price: 4299,
        description: 'Simple, low-top lace-up with sturdy canvas upper. The original classic since 1966.',
        imageUrl: 'https://images.vans.com/is/image/Vans/EE3BLK-HERO?wid=1600&hei=1984&fmt=jpeg&qlt=90&resMode=sharp2&op_usm=0.9,1.7,8,0',
        availableSizes: [6, 7, 8, 9, 10, 11],
        colors: ['Black', 'White', 'Navy'],
        gender: 'Unisex',
        rating: 4.4,
        stock: 100,
      ),

      // Women's Specific
      Shoe(
        name: 'Nike Air Zoom Pegasus 39',
        brand: 'Nike',
        category: 'Running',
        price: 10995,
        description: 'Responsive cushioning and smooth ride for runners. Built for comfort on every run.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/88d9ff5e-4f6a-41f4-92f1-d4e88f5e0b46/air-zoom-pegasus-39-road-running-shoes-FKQ4fM.png',
        availableSizes: [5, 6, 7, 8, 9, 10],
        colors: ['Pink', 'White', 'Black', 'Purple'],
        gender: 'Women',
        rating: 4.6,
        stock: 55,
      ),
      Shoe(
        name: 'Adidas NMD R1',
        brand: 'Adidas',
        category: 'Casual',
        price: 12999,
        description: 'Modern street style with innovative Boost cushioning. Comfort meets fashion.',
        imageUrl: 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/a69e58ed40f444b4b6d7ab3c00a8d6b4_9366/NMD_R1_Shoes_White_GZ7922_01_standard.jpg',
        availableSizes: [5, 6, 7, 8, 9, 10],
        colors: ['White', 'Black', 'Pink'],
        gender: 'Women',
        rating: 4.5,
        stock: 50,
      ),

      // Sports Specific
      Shoe(
        name: 'Nike Mercurial Superfly',
        brand: 'Nike',
        category: 'Football',
        price: 24995,
        description: 'Elite football boots for speed and precision. Built for the world\'s fastest players.',
        imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/e67fd5c7-5b28-48c1-a64a-6c542a7cfa49/mercurial-superfly-9-elite-fg-football-boot-LqWGGG.png',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['Black', 'White', 'Red'],
        gender: 'Men',
        rating: 4.8,
        stock: 25,
      ),
      Shoe(
        name: 'Asics Gel-Kayano 29',
        brand: 'Asics',
        category: 'Running',
        price: 14995,
        description: 'Premium stability running shoe with excellent support for long distances.',
        imageUrl: 'https://images.asics.com/is/image/asics/1011B440_001_SR_RT_GLB',
        availableSizes: [7, 8, 9, 10, 11, 12],
        colors: ['Black', 'Blue', 'Grey'],
        gender: 'Men',
        rating: 4.7,
        stock: 40,
      ),
    ];

    // Insert all sample shoes
    for (final shoe in sampleShoes) {
      await db.insertShoe(shoe);
    }

    print('Sample data generated: ${sampleShoes.length} shoes added');
  }
}
