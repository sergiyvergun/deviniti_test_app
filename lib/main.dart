import 'package:flutter/material.dart';
import 'package:plants_app/pages/app.dart';
import 'package:provider/provider.dart';
import 'database/dao.dart';
import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final dao = database.dao;
  runApp(
    Provider<Dao>(
      create: (BuildContext context) => dao,
      child: const PlantsApp(),
    ),
  );
}
