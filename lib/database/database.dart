// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/plant.dart';
import '../models/plant_type.dart';
import 'dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [PlantType, Plant])
abstract class AppDatabase extends FloorDatabase {
  Dao get dao;
}