import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/dao.dart';
import '../models/plant.dart';

import 'package:flutter/foundation.dart';

abstract class SearchPlantsState {
  final List<Plant>? plants;

  SearchPlantsState({required this.plants});
}

class SearchPlantsInitialState extends SearchPlantsState {
  @override
  final List<Plant>? plants;

  SearchPlantsInitialState({required this.plants}) : super(plants: plants);
}

class SearchPlantsRequested extends SearchPlantsState {
  @override
  final List<Plant>? plants;

  SearchPlantsRequested({required this.plants}) : super(plants: plants);
}

class SearchPlantsRequestSucceed extends SearchPlantsState {
  @override
  final List<Plant>? plants;

  SearchPlantsRequestSucceed({required this.plants}) : super(plants: plants);
}

class SearchPlantsRequestFailed extends SearchPlantsState {
  @override
  final List<Plant>? plants;

  SearchPlantsRequestFailed({required this.plants}) : super(plants: plants);
}

class SearchPlantsCubit extends Cubit<SearchPlantsState> {
  SearchPlantsCubit() : super(SearchPlantsInitialState(plants: []));

  late List<Plant> plants;
  late Dao dao;
  String searchText = '';

  Future<void> init() async {
    plants = await dao.findAllPlants();
    emit(SearchPlantsRequestSucceed(plants: plants));
  }

  search(String? text) async {
    try {
      if (text != null) {
        searchText = text;
      }
      emit(SearchPlantsRequested(plants: plants));
      plants = (await dao.findAllPlants())
          .where((Plant plant) =>
              plant.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      emit(SearchPlantsRequestSucceed(plants: plants));
    } catch (e) {
      emit(SearchPlantsRequestFailed(plants: plants));
      rethrow;
    }
  }
}
