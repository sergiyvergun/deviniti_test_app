// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/search_plants_cubit.dart';
import '../database/dao.dart';
import '../models/plant.dart';
import '../models/plant_type.dart';
import 'add_plant_page.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: [
          const _SearchBar(),
          const _PlantsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddPlantPage())),
        tooltip: 'Increment',
        label: Row(
          children: const [
            Icon(Icons.add),
            Text('Add Plant'),
          ],
        ),
      ),
    );
  }
}

class _PlantsList extends StatefulWidget {
  const _PlantsList({Key? key}) : super(key: key);

  @override
  State<_PlantsList> createState() => _PlantsListState();
}

class _PlantsListState extends State<_PlantsList> {
  late SearchPlantsCubit _searchPlantsCubit;

  @override
  void didChangeDependencies() async {
    _searchPlantsCubit = BlocProvider.of<SearchPlantsCubit>(context);
    _searchPlantsCubit.dao = Provider.of<Dao>(context);
    await _searchPlantsCubit.init();
    print(_searchPlantsCubit.plants.length);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _searchPlantsCubit,
        builder: (context, SearchPlantsState state) {
          if(state.plants!.isEmpty){
            return Center(child: Text('No plants found'));
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.plants!.length,
              itemBuilder: (context, int index) {
                return _PlantTile(
                  plant: state.plants!.elementAt(index),
                );
              });
        });
  }
}

class _PlantTile extends StatelessWidget {
  final Plant plant;

  const _PlantTile({Key? key, required this.plant}) : super(key: key);

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(plant.date);

  @override
  Widget build(BuildContext context) {
    final dao = Provider.of<Dao>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddPlantPage(plant: plant)));
      },
      child: ListTile(
        title: Row(
          children: [
            Text(
              '${plant.name[0]} ${plant.name[plant.name.length - 1]} ',
              style: const TextStyle(color: Colors.black),
            ),
            Container(width: 20),
            Expanded(child: Text(plant.name,
              overflow: TextOverflow.ellipsis,)),
            Spacer(),
            Text(DateFormat.yMMMd().format(date)),
            Container(
              width: 10,
            ),
            StreamBuilder(
                stream: dao.findPlantTypeById(plant.plantTypeId),
                builder: (context, AsyncSnapshot<PlantType?> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!.name);
                  }
                  return Text('Loading');
                }),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late TextEditingController textEditingController;

  @override
  void didChangeDependencies() {
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      BlocProvider.of<SearchPlantsCubit>(context, listen: false)
          .search(textEditingController.text);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search'),
        controller: textEditingController,
      ),
    );
  }
}
