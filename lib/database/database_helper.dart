import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:lipalocal/screens/orders_screen.dart';

class DatabaseHelper {
  static Database? _database;
  static const _databaseVersion = 3; // Incremented for location columns

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'lipalocal.db');
    
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _upgradeDatabase(db, oldVersion, newVersion);
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Tourists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phoneNumber TEXT,
        country TEXT,
        passwordHash TEXT NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Artisans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phoneNumber TEXT,
        skill TEXT,
        businessName TEXT,
        passwordHash TEXT NOT NULL,
        latitude REAL,
        longitude REAL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Orders (
        id TEXT PRIMARY KEY,
        touristId INTEGER,
        artisanId INTEGER,
        productId TEXT,
        productName TEXT,
        productPrice REAL,
        quantity INTEGER,
        status TEXT DEFAULT 'pending',
        orderTime TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(touristId) REFERENCES Tourists(id),
        FOREIGN KEY(artisanId) REFERENCES Artisans(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Settings (
        userId INTEGER PRIMARY KEY,
        notificationsEnabled INTEGER DEFAULT 1,
        darkModeEnabled INTEGER DEFAULT 0,
        language TEXT DEFAULT 'en',
        FOREIGN KEY(userId) REFERENCES Tourists(id) ON DELETE CASCADE,
        FOREIGN KEY(userId) REFERENCES Artisans(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Products (
        id TEXT PRIMARY KEY,
        artisanId INTEGER,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT,
        imageUrl TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(artisanId) REFERENCES Artisans(id) ON DELETE CASCADE
      )
    ''');
  }

  static Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE Tourists ADD COLUMN passwordHash TEXT NOT NULL DEFAULT ""');
      await db.execute('ALTER TABLE Artisans ADD COLUMN passwordHash TEXT NOT NULL DEFAULT ""');
      await db.execute('ALTER TABLE Artisans ADD COLUMN businessName TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE Artisans ADD COLUMN latitude REAL');
      await db.execute('ALTER TABLE Artisans ADD COLUMN longitude REAL');
    }
  }

  // ================== User Operations ==================
  static String _hashPassword(String password) {
    final bytes = utf8.encode('${password}lipalocal_salt');
    return sha256.convert(bytes).toString();
  }

  static Future<int> insertUser(Map<String, dynamic> user, bool isArtisan) async {
    final db = await database;
    user['passwordHash'] = _hashPassword(user['password']);
    return await db.insert(isArtisan ? 'Artisans' : 'Tourists', user);
  }

  static Future<int> insertArtisan(Map<String, dynamic> artisan) async {
    return insertUser(artisan, true);
  }

  static Future<int> insertTourist(Map<String, dynamic> tourist) async {
    return insertUser(tourist, false);
  }

  static Future<Map<String, dynamic>?> authenticateUser(String email, String password, bool isArtisan) async {
    final db = await database;
    final result = await db.query(
      isArtisan ? 'Artisans' : 'Tourists',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isNotEmpty && _hashPassword(password) == result.first['passwordHash']) {
      return result.first;
    }
    return null;
  }

  // ================== Artisan Location Operations ==================
  static Future<List<Map<String, dynamic>>> getArtisansWithLocations() async {
    final db = await database;
    return await db.query(
      'Artisans',
      columns: ['id', 'fullName', 'businessName', 'skill', 'latitude', 'longitude'],
      where: 'latitude IS NOT NULL AND longitude IS NOT NULL',
    );
  }

  static Future<int> updateArtisanLocation(int artisanId, double latitude, double longitude) async {
    final db = await database;
    return await db.update(
      'Artisans',
      {
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [artisanId],
    );
  }

  // ================== Order Operations ==================
  static Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('Orders', order);
  }

  static Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Orders');
    return List.generate(maps.length, (i) => Order.fromMap(maps[i]));
  }

  static Future<List<Map<String, dynamic>>> getUserOrders(String userId, bool isArtisan) async {
    final db = await database;
    return await db.query(
      'Orders',
      where: isArtisan ? 'artisanId = ?' : 'touristId = ?',
      whereArgs: [userId],
    );
  }

  // ================== Product Operations ==================
  static Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('Products', product);
  }

  static Future<List<Map<String, dynamic>>> getArtisanProducts(String artisanId) async {
    final db = await database;
    return await db.query(
      'Products',
      where: 'artisanId = ?',
      whereArgs: [artisanId],
    );
  }

  // ================== Settings Operations ==================
  static Future<Map<String, dynamic>?> getSettings(int userId) async {
    final db = await database;
    final result = await db.query(
      'Settings',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> saveSettings(int userId, Map<String, dynamic> settings) async {
    final db = await database;
    settings['userId'] = userId;
    return await db.insert(
      'Settings',
      settings,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ================== Helper Methods ==================
  static Future<List<Map<String, dynamic>>> queryData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getArtisans() async {
    return queryData('Artisans');
  }

  static Future<int> updateData(String table, int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteData(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}