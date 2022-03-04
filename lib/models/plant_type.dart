import 'package:floor/floor.dart';

@entity
class PlantType {
  @primaryKey
  final int id;

  final String name;

  PlantType({required this.id, required this.name});
}
