import 'package:flutter/material.dart';
import 'package:plants_app/models/plant_type.dart';
import 'package:provider/provider.dart';

import '../database/dao.dart';
import 'home_page.dart';

class PlantsApp extends StatefulWidget {
  const PlantsApp({Key? key}) : super(key: key);

  @override
  State<PlantsApp> createState() => _PlantsAppState();
}

class _PlantsAppState extends State<PlantsApp> {
  late Dao dao;

  @override
  void didChangeDependencies() async {
    dao = Provider.of<Dao>(context);
    if ((await dao.findAllPlantTypes()).isEmpty) {
      dao
        ..insertPlantType(PlantType(id: 0, name: 'Alpines'))
        ..insertPlantType(PlantType(id: 1, name: 'Aquatic'))
        ..insertPlantType(PlantType(id: 2, name: 'Bulbs'))
        ..insertPlantType(PlantType(id: 3, name: 'Succulents'))
        ..insertPlantType(PlantType(id: 4, name: 'Carnivorous'))
        ..insertPlantType(PlantType(id: 5, name: 'Climbers'))
        ..insertPlantType(PlantType(id: 6, name: 'Ferns'))
        ..insertPlantType(PlantType(id: 7, name: 'Grasses'))
        ..insertPlantType(PlantType(id: 8, name: 'Threes'));
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garden',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Garden'),
    );
  }
}
