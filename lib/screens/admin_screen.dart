import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../database/database_helper.dart';
import '../providers/shoe_provider.dart';
import '../providers/cart_provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _isLoading = false;
  int _shoeCount = 0;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final shoeCount = await DatabaseHelper.instance.getShoeCount();
    final cartItemCount = await DatabaseHelper.instance.getCartItemCount();
    
    setState(() {
      _shoeCount = shoeCount;
      _cartItemCount = cartItemCount;
    });
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      
      // For Android 13+
      if (await Permission.photos.isDenied) {
        await Permission.photos.request();
      }
      if (await Permission.videos.isDenied) {
        await Permission.videos.request();
      }
    }
  }

  Future<void> _exportDatabase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _requestPermissions();

      // Get the Downloads directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        throw Exception('Could not access storage');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'shoe_store_$timestamp.db';
      final filePath = '${directory.path}/$fileName';

      final success = await DatabaseHelper.instance.exportDatabase(filePath);

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database exported to:\n$filePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        throw Exception('Export failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importDatabase() async {
    try {
      await _requestPermissions();

      // Pick a database file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db', 'sqlite', 'sqlite3'],
      );

      if (result == null) return;

      setState(() {
        _isLoading = true;
      });

      final filePath = result.files.single.path;
      if (filePath == null) {
        throw Exception('File path is null');
      }

      // Show confirmation dialog
      if (!mounted) return;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Import Database'),
          content: const Text(
            'This will replace all existing data. Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Import',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final success = await DatabaseHelper.instance.importDatabase(filePath);

      if (success) {
        // Reload data in providers
        if (!mounted) return;
        await context.read<ShoeProvider>().loadShoes();
        await context.read<CartProvider>().loadCart();
        await _loadStatistics();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database imported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Import failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error importing database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all shoes and cart items. This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.deleteAllShoes();
      await DatabaseHelper.instance.clearCart();

      if (!mounted) return;
      await context.read<ShoeProvider>().loadShoes();
      await context.read<CartProvider>().loadCart();
      await _loadStatistics();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All data cleared'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showDatabaseInfo() async {
    final dbPath = await DatabaseHelper.instance.getDatabasePath();
    final dbFile = File(dbPath);
    final exists = await dbFile.exists();
    final size = exists ? await dbFile.length() : 0;
    final sizeInKB = (size / 1024).toStringAsFixed(2);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Database Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Path: $dbPath'),
            const SizedBox(height: 8),
            Text('Size: $sizeInKB KB'),
            const SizedBox(height: 8),
            Text('Shoes: $_shoeCount'),
            const SizedBox(height: 8),
            Text('Cart Items: $_cartItemCount'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Statistics Card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Database Statistics',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.shopping_bag,
                              label: 'Total Shoes',
                              value: _shoeCount.toString(),
                              color: Colors.blue,
                            ),
                            _buildStatItem(
                              icon: Icons.shopping_cart,
                              label: 'Cart Items',
                              value: _cartItemCount.toString(),
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Database Operations
                const Text(
                  'Database Operations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Import Database Button
                _buildActionCard(
                  icon: Icons.upload_file,
                  title: 'Import Database',
                  description: 'Import a database file from your device',
                  color: Colors.green,
                  onTap: _importDatabase,
                ),
                const SizedBox(height: 12),

                // Export Database Button
                _buildActionCard(
                  icon: Icons.download,
                  title: 'Export Database',
                  description: 'Export database to Downloads folder',
                  color: Colors.blue,
                  onTap: _exportDatabase,
                ),
                const SizedBox(height: 12),

                // Database Info Button
                _buildActionCard(
                  icon: Icons.info_outline,
                  title: 'Database Information',
                  description: 'View database details and statistics',
                  color: Colors.purple,
                  onTap: _showDatabaseInfo,
                ),
                const SizedBox(height: 12),

                // Clear All Data Button
                _buildActionCard(
                  icon: Icons.delete_forever,
                  title: 'Clear All Data',
                  description: 'Delete all shoes and cart items',
                  color: Colors.red,
                  onTap: _clearAllData,
                ),
                const SizedBox(height: 24),

                // Instructions
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '1. Export the database to edit it on your computer',
                          style: TextStyle(height: 1.5),
                        ),
                        const Text(
                          '2. Use SQLite Browser or similar tools to add/edit shoes',
                          style: TextStyle(height: 1.5),
                        ),
                        const Text(
                          '3. Import the modified database back to the app',
                          style: TextStyle(height: 1.5),
                        ),
                        const Text(
                          '4. All changes will be reflected immediately',
                          style: TextStyle(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 48, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
