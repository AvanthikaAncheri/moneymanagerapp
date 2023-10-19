import 'package:flutter/material.dart';
import 'package:project11/db/category/category_db.dart';
import 'package:project11/screens/catagory/Expense_catagory_list.dart';
import 'package:project11/screens/catagory/income_catagory_list.dart';

class ScreenCatagory extends StatefulWidget {
  const ScreenCatagory({super.key});

  @override
  State<ScreenCatagory> createState() => _ScreenCatagoryState();
}

class _ScreenCatagoryState extends State<ScreenCatagory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [Tab(text: 'INCOME'), Tab(text: 'EXPENSE')]),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [IncomeCategoryList(), ExpenseCategoryList()],
          ),
        )
      ],
    );
  }
}
