import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:shopping_list/Data/categories.dart';
import 'package:shopping_list/Models/category.dart';
// import 'package:shopping_list/Models/grocery_items.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 0;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItems() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final url = Uri.https('shoping-list-2641f-default-rtdb.firebaseio.com',
          'shopping-list.json');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'name': _enteredName,
              'quantity': _enteredQuantity,
              'category': _selectedCategory.title,
            },
          ));

      print(response.body);
      print(response.statusCode);
      Get.back();

      // Get.back(
      //   result: GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: _enteredQuantity,
      //     category: _selectedCategory,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new item List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (Value) {
                  if (Value == null ||
                      Value.isEmpty ||
                      Value.trim().length <= 1 ||
                      Value.trim().length > 50) {
                    return ' must be between 1 to 50 characters';
                  }
                  return null;
                },
                onSaved: (Value) {
                  _enteredName = Value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text('Quantity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (Value) {
                        if (Value == null ||
                            Value.isEmpty ||
                            int.tryParse(Value) == null ||
                            int.tryParse(Value)! <= 0) {
                          return 'must be a valid, positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        items: [
                          for (final Category in categories.entries)
                            DropdownMenuItem(
                              value: Category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: Category.value.color,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(Category.value.title),
                                ],
                              ),
                            )
                        ],
                        onChanged: (Value) {
                          setState(() {
                            _selectedCategory = Value!;
                          });
                        }),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formkey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: _saveItems, child: const Text('Add Items'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
