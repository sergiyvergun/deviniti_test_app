// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:plants_app/models/plant_type.dart';

import '../models/plant.dart';

@dao
abstract class Dao {
  @Query('SELECT * FROM PlantType')
  Future<List<PlantType>> findAllPlantTypes();

  @Query('SELECT * FROM PlantType WHERE id = :id')
  Stream<PlantType?> findPlantTypeById(int id);

  @insert
  Future<void> insertPlantType(PlantType plantType);

  @Query('SELECT * FROM Plant')
  Future<List<Plant>> findAllPlants();

  @Query('SELECT * FROM Plant WHERE id = :id')
  Stream<PlantType?> findPlantById(int id);

  @insert
  Future<void> insertPlant(Plant plant);

  @update
  Future<void> updatePlant(Plant plant);
}
