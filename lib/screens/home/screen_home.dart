import 'package:flutter/material.dart';
import 'package:project11/db/category/category_db.dart';
import 'package:project11/db/transactions/transactions_db.dart';
import 'package:project11/models/category/category_model.dart';
import 'package:project11/screens/add_transactions/screen_add_transactions.dart';
import 'package:project11/screens/catagory/category_add_popup.dart';
import 'package:project11/screens/catagory/screen_catagory.dart';
import 'package:project11/screens/home/widgets/bottom_navigation.dart';
import 'package:project11/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCatagory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 228, 228),
      appBar: AppBar(
        title: Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext context, int updatedIndex, child) {
                return _pages[updatedIndex];
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('Add Transaction');
            Navigator.of(context).pushNamed(ScreenaddTransactions.routename);
          } else {
            print('Add Category');

            showCategoryAddPopup(context);
            // final _sample = Categorymodel(
            //     id: DateTime.now().millisecondsSinceEpoch.toString(),
            //     name: "Moneymanaging",
            //     type: CategoryType.expense);

            // CategoryDb().insertCategory(_sample);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
