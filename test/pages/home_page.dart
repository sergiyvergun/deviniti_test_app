import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plants_app/pages/add_plant_page.dart';
import 'package:plants_app/pages/app.dart';

void main() {
  setUp(() async {});

  tearDown(() async {});

  testWidgets('Tapping add plant opens add_plant_page', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(PlantsApp());
      final fabFinder = find.byType(FloatingActionButton);
      await tester.tap(fabFinder);
      expect(find.byType(AddPlantPage), findsOneWidget);
    });
  });
}
