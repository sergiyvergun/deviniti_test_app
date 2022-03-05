import 'package:floor/floor.dart';

@entity
class Plant {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final int plantTypeId;

  final int date;

  Plant({
     this.id,
    required this.name,
    required this.plantTypeId,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Plant &&
              runtimeType == other.runtimeType &&
              id == other.id;
}
