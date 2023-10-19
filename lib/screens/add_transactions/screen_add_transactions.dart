import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project11/db/category/category_db.dart';
import 'package:project11/db/transactions/transactions_db.dart';
import 'package:project11/models/category/category_model.dart';
import 'package:project11/models/transactions/transaction_model.dart';

class ScreenaddTransactions extends StatefulWidget {
  static const routename = 'add-transactions';
  const ScreenaddTransactions({super.key});

  @override
  State<ScreenaddTransactions> createState() => _ScreenaddTransactionsState();
}

class _ScreenaddTransactionsState extends State<ScreenaddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  Categorymodel? _selectedcategoryModel;
  String? _categoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //purpose
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Purpose'),
            ),
            //amount
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            //calender

            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now());
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  print(_selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate.toString()),
            ),

            //category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategorytype = CategoryType.income;
                            _categoryID = null;
                          });
                        }),
                    Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategorytype,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategorytype = CategoryType.expense;
                            _categoryID = null;
                          });
                        }),
                    Text('Expense'),
                  ],
                ),
              ],
            ),

            //categorytype dropdown
            DropdownButton<String>(
              hint: const Text('Select Category'),
              value: _categoryID,
              items:

                  ///ternery operator
                  (_selectedCategorytype == CategoryType.income
                          ? CategoryDb().incomeCategoryListListener
                          : CategoryDb.instance.expenseCategoryListListener)
                      .value
                      .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    print(e.toString());
                    _selectedcategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                print(selectedValue);
                setState(() {
                  _categoryID = selectedValue;
                });
              },
            ),
            //submit button

            ElevatedButton(
              onPressed: () {
                addTransaction();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    //if (_categoryID == null) {
    // return;
    //}
    if (_selectedDate == null) {
      return;
    }
    if (_selectedcategoryModel == null) {
      return;
    }

    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }

    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedcategoryModel!,
    );
    await TransactionDB.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }
}
