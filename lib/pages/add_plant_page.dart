// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    print('saving');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant == null ? 'Add Plant' : 'Update Plant'),
        actions: [
          FlatButton(
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

                  return DropdownButton(
                      isExpanded: true,
                      value: plantTypes!.elementAt(_selectedPlantType).id,
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
