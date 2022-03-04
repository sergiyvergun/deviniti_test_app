// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:plants_app/models/plant_type.dart';

@dao
abstract class Dao {
  @Query('SELECT * FROM PlantType')
  Future<List<PlantType>> findAllPlantTypes();

  @Query('SELECT * FROM PlantType WHERE id = :id')
  Stream<PlantType?> findPlantTypeById(int id);

  @insert
  Future<void> insertPlantType(PlantType plantType);
}
