import 'dart:html';
import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:project11/models/category/category_model.dart';
import 'package:project11/screens/catagory/income_catagory_list.dart';

const CATEGORY_DB_NAME = 'category-database';

abstract class CategoryDbFunctions {
  Future<List<Categorymodel>> getCategories();
  Future<void> insertCategory(Categorymodel value);
  Future<void> deleteCategory(String categoryID);
}

class CategoryDb implements CategoryDbFunctions {
  CategoryDb._internal();

  static CategoryDb instance = CategoryDb._internal();

  factory CategoryDb() {
    return instance;
  }

  ValueNotifier<List<Categorymodel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<Categorymodel>> expenseCategoryListListener =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(Categorymodel value) async {
    final _categoryDB = await Hive.openBox<Categorymodel>(CATEGORY_DB_NAME);
    await _categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<Categorymodel>> getCategories() async {
    final _categoryDB = await Hive.openBox<Categorymodel>(CATEGORY_DB_NAME);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final _allCategories = await getCategories();
    incomeCategoryListListener.value.clear();
    expenseCategoryListListener.value.clear();
    await Future.forEach(_allCategories, (Categorymodel categoy) {
      if (categoy.type == CategoryType.income) {
        incomeCategoryListListener.value.add(categoy);
      } else {
        expenseCategoryListListener.value.add(categoy);
      }
      ;
    });
    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<Categorymodel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    refreshUI();
  }
}
