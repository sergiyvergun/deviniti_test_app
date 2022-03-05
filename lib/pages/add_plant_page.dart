// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plants_app/blocs/search_plants_cubit.dart';
import 'package:plants_app/models/plant_type.dart';
import 'package:provider/provider.dart';

import '../database/dao.dart';
import '../models/plant.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({Key? key, this.plant}) : super(key: key);

  final Plant? plant;

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  late TextEditingController _nameTextEditingController;
  late int _selectedPlantType;
  late int _date;

  get selectedDate => DateTime.fromMillisecondsSinceEpoch(_date);

  @override
  void initState() {
    _nameTextEditingController = TextEditingController();
    _selectedPlantType = 0;
    _date = DateTime.now().millisecondsSinceEpoch;

    if (widget.plant != null) {
      _nameTextEditingController.text = widget.plant!.name;
      _selectedPlantType = widget.plant!.plantTypeId;
      _date = widget.plant!.date;
    }
    super.initState();
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected.millisecondsSinceEpoch != _date) {
      setState(() {
        _date = selected.millisecondsSinceEpoch;
      });
    }
  }

  void _save() {
    if (_nameTextEditingController.text.isNotEmpty) {
      if (widget.plant == null) {
        Provider.of<Dao>(context, listen: false).insertPlant(Plant(
            id: null,
            name: _nameTextEditingController.text,
            plantTypeId: _selectedPlantType,
            date: _date));
      } else {
        Provider.of<Dao>(context, listen: false).updatePlant(Plant(
            id: widget.plant!.id,
            name: _nameTextEditingController.text,
            plantTypeId: _selectedPlantType,
            date: _date));
      }

      Navigator.of(context).pop();
      BlocProvider.of<SearchPlantsCubit>(context).search(null);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_nameTextEditingController.text} saved')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Provide some input')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant == null ? 'Add Plant' : 'Update Plant'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameTextEditingController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            FutureBuilder<List<PlantType>>(
                future: Provider.of<Dao>(context).findAllPlantTypes(),
                builder: (context, AsyncSnapshot<List<PlantType>> snapshot) {
                  List<PlantType>? plantTypes = snapshot.data;

                  if (plantTypes != null) {
                    return DropdownButton(
                        isExpanded: true,
                        value: plantTypes.elementAt(_selectedPlantType).id,
                        hint: Text('Type'),
                        items: plantTypes
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e.id,
                                ))
                            .toList(),
                        onChanged: (int? value) {
                          setState(() {
                            _selectedPlantType = value!;
                          });
                        });
                  } else {
                    return Container();
                  }
                }),
            TextButton(
              onPressed: () {
                _selectDate(context);
              },
              child: Row(
                children: [
                  Text('Date'),
                  Spacer(),
                  Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
