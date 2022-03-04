// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../models/plant.dart';

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({Key? key, this.plant}) : super(key: key);

  final Plant? plant;

  @override
  _AddPlantPageState createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {

  late TextEditingController _nameTextEditingController;

  @override
  void initState() {
    _nameTextEditingController = TextEditingController();
    super.initState();
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
          children:  [
            TextField(
              controller: _nameTextEditingController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
          ],
        ),
      ),
    );
  }
}
