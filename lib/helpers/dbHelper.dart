import 'dart:async';
import 'package:path/path.dart';
import 'package:shopping_cart/models/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDataBaseHelper {

  /// Using private constructor we can ensure that no more than one object can be created at a time.
  /// By providing a private constructor you prevent class instances from being created in any place other than this very class.
  ItemsDataBaseHelper.internal();
  /// Here we create the instance of the class at the time of declaring the static data member,
  /// so instance of the class is created at the time of classloading.
  /// It represents Singleton Design pattern of Early instantiation
  static final ItemsDataBaseHelper _dataBaseHelperInstance =
  new ItemsDataBaseHelper.internal();

  ///Private constructor, it will prevent to instantiate the Singleton class from outside the class.

  /// Use the factory keyword when implementing a constructor that doesn't always create a new instance of its class.
  /// For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.
  factory ItemsDataBaseHelper() => _dataBaseHelperInstance;

  /// Database table name and it should be final and it should not be changed. That's why we declared as final
  final String itemsTable = 'Items';

  /// Base class of Database from Sqflite plugin. It's an abstract class to send SQL commands for CRUD Operations
  static Database _itemsDatabase;

  /// To perform asynchronous operations in Dart, you can use the Future class and the async and await keywords.
  ///
  /// refer to this link for better understanding of the Future, async and await keywords
  /// https://dart.dev/codelabs/async-await
  ///
  /// A future (lower case “f”) is an instance of the Future (capitalized “F”) class.
  /// A future represents the result of an asynchronous operation, and can have two states: uncompleted or completed.
  Future<Database> get db async {
    if (_itemsDatabase != null) {
      return _itemsDatabase;
    }
    _itemsDatabase = await initDb();

    return _itemsDatabase;
  }

  /// For async keyword, please refer to the below link
  /// https://dart.dev/guides/language/language-tour#asynchrony-support
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'items.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  /// Method to create the DB with Database variable and Dbversion
  void _onCreate(Database db, int dbVersion) async {
    await db.execute(
        "CREATE TABLE $itemsTable(title TEXT PRIMARY KEY, "
            "description TEXT, price TEXT, category TEXT, "
            "image TEXT)");
  }

  /// Method to insert the data into DB with insert query by passing table name and model data
  Future<int> saveItemsDetails(Item items) async {
    print("save Items");
    print(items.toMap());
    var dbClient = await db;
    int result = await dbClient.insert(itemsTable, items.toMap());
    print("result");
    print(result);
    return result;
  }

  /// Method to fetch all the user information from the Database using rawQuery
  Future<List<Item>> getItemsofCategory(itemCategory) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Items WHERE category = ?',[itemCategory]);
    List<Item> items = new List();
    for (int i = 0; i < list.length; i++) {
      var user = new Item(
        title: list[i]["title"],
        description: list[i]["description"],
        price: list[i]["price"],
       // colors: list[i]["colors"],
        category: list[i]["category"],
        image: list[i]["image"]
      );
      //user.setUserId(list[i]["id"]);
      items.add(user);
    }
    print("DB data.... " + items.toString());
    return items;
  }

  /// Method to fetch all the user information from the Database using rawQuery
  Future<int> deleteUsers(Item items) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM Items WHERE title = ?', [items.title]);
    return res;
  }

  /// Method to delete all the user information from the Database using rawDelete
  Future<int> deleteAllUsers() async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM Items');
    return res;
  }

  /// Method to update the items information using update query.
  Future<bool> update(Item items) async {
    print(items.toMap());
    var dbClient = await db;
    int res = await dbClient.update("Items", items.toMap(),
        where: "title = ?", whereArgs: <String>[items.title]);
    print(res);
    return res > 0 ? true : false;
  }

}