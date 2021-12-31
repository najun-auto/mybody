
import 'package:mybody/data/data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "eybody.db";
  static final int _databaseVersion = 1;
  static final foodTable = "food";
  static final workoutTable = "workout";
  static final eyebodyTable = "eyeBody";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $foodTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      type INTEGER DEFAULT 0,
      kcal INTEGER DEFAULT 0,
      image String,
      memo String    
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $workoutTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      time INTEGER DEFAULT 0,
      name String,
      image String,
      memo String    
    )
    ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $eyebodyTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date INTEGER DEFAULT 0,
      weight INTEGER DEFAULT 0,      
      image String          
    )
    ''');

  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertFood(Food food) async{
    Database db = await instance.database;

    if(food.id == null){
      final map = food.toMap();
      return await db.insert(foodTable, map);
    }else{
      final map = food.toMap();
      return await db.update(foodTable, map);
    }
  }

  Future<List<Food>> queryFoodByDate(int date) async{
    Database db = await instance.database;
    List<Food> foods = [];

    final query = await db.query(foodTable, where: "date = ?", whereArgs: [date]);
    for(final r in query){
      foods.add(Food.fromDB(r));
    }
    return foods;
  }

  Future<List<Food>> queryAllFood(int date) async{
    Database db = await instance.database;
    List<Food> foods = [];

    final query = await db.query(foodTable);
    for(final r in query){
      foods.add(Food.fromDB(r));
    }
    return foods;
  }

  Future<int> insertWorkout(Workout workout) async{
    Database db = await instance.database;

    if(workout.id == null){
      final map = workout.toMap();
      return await db.insert(workoutTable, map);
    }else{
      final map = workout.toMap();
      return await db.update(workoutTable, map);
    }
  }

  Future<List<Workout>> queryWorkoutByDate(int date) async{
    Database db = await instance.database;
    List<Workout> workouts = [];

    final query = await db.query(workoutTable, where: "date = ?", whereArgs: [date]);
    for(final r in query){
      workouts.add(Workout.fromDB(r));
    }
    return workouts;
  }

  Future<List<Workout>> queryAllWorkout(int date) async{
    Database db = await instance.database;
    List<Workout> workouts = [];

    final query = await db.query(workoutTable);
    for(final r in query){
      workouts.add(Workout.fromDB(r));
    }
    return workouts;
  }

  Future<int> insertEyeBody(EyeBody eyeBody) async{
    Database db = await instance.database;

    if(eyeBody.id == null){
      final map = eyeBody.toMap();
      return await db.insert(eyebodyTable, map);
    }else{
      final map = eyeBody.toMap();
      return await db.update(eyebodyTable, map);
    }
  }

  Future<List<EyeBody>> queryEyeBodyByDate(int date) async{
    Database db = await instance.database;
    List<EyeBody> eyeBodys = [];

    final query = await db.query(eyebodyTable, where: "date = ?", whereArgs: [date]);
    for(final r in query){
      eyeBodys.add(EyeBody.fromDB(r));
    }
    return eyeBodys;
  }

  Future<List<EyeBody>> queryAllEyeBody(int date) async{
    Database db = await instance.database;
    List<EyeBody> eyeBodys = [];

    final query = await db.query(eyebodyTable);
    for(final r in query){
      eyeBodys.add(EyeBody.fromDB(r));
    }
    return eyeBodys;
  }

}