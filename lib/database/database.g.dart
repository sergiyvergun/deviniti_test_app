// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  Dao? _daoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PlantType` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Plant` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `plantTypeId` INTEGER NOT NULL, `date` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  Dao get dao {
    return _daoInstance ??= _$Dao(database, changeListener);
  }
}

class _$Dao extends Dao {
  _$Dao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _plantTypeInsertionAdapter = InsertionAdapter(
            database,
            'PlantType',
            (PlantType item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _plantInsertionAdapter = InsertionAdapter(
            database,
            'Plant',
            (Plant item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'plantTypeId': item.plantTypeId,
                  'date': item.date
                }),
        _plantUpdateAdapter = UpdateAdapter(
            database,
            'Plant',
            ['id'],
            (Plant item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'plantTypeId': item.plantTypeId,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PlantType> _plantTypeInsertionAdapter;

  final InsertionAdapter<Plant> _plantInsertionAdapter;

  final UpdateAdapter<Plant> _plantUpdateAdapter;

  @override
  Future<List<PlantType>> findAllPlantTypes() async {
    return _queryAdapter.queryList('SELECT * FROM PlantType',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int, name: row['name'] as String));
  }

  @override
  Stream<PlantType?> findPlantTypeById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM PlantType WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int, name: row['name'] as String),
        arguments: [id],
        queryableName: 'PlantType',
        isView: false);
  }

  @override
  Future<List<Plant>> findAllPlants() async {
    return _queryAdapter.queryList('SELECT * FROM Plant',
        mapper: (Map<String, Object?> row) => Plant(
            id: row['id'] as int?,
            name: row['name'] as String,
            plantTypeId: row['plantTypeId'] as int,
            date: row['date'] as int));
  }

  @override
  Stream<PlantType?> findPlantById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Plant WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            PlantType(id: row['id'] as int, name: row['name'] as String),
        arguments: [id],
        queryableName: 'PlantType',
        isView: false);
  }

  @override
  Future<void> insertPlantType(PlantType plantType) async {
    await _plantTypeInsertionAdapter.insert(
        plantType, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPlant(Plant plant) async {
    await _plantInsertionAdapter.insert(plant, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePlant(Plant plant) async {
    await _plantUpdateAdapter.update(plant, OnConflictStrategy.abort);
  }
}
