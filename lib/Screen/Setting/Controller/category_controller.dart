import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Authentication/fire_service.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final FirestoreService firebaseService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nameKhController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController iconController = TextEditingController();
  var selectedIndex = 0;
  var isLoading = false;
  IconData? pickicon;
  var categories = <String, List<Category>>{};
  List<Category> firebaseExpenseCategories = [];
  List<Category> firebaseIncomeCategories = [];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void selectCategory(int index) {
    selectedIndex = index;
    update();
  }


  void addCategory() async {
    if (selectedIndex >= 0) {
      Filter selectedCategory = filter[selectedIndex];
      await firebaseService.addCategory(
        name: nameController.text,
        namekh: nameKhController.text,
        type: selectedCategory.title,
        icon: iconToString(pickicon!),
      ).then((_) {
        nameController.clear();
        nameKhController.clear();


        // Show success message or navigate to another page
        print('Category added successfully!');
      }).catchError((error) {
        print('Error adding category: $error');
        // Handle error
      });
    } else {
      print('No category selected');
    }
  }

  void deleteTran(String id) async {
    await firebaseService.deleteCategory(id);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text('Transaction deleted successfully')),
    );
    update();
  }

  String iconToString(IconData icon) {
    return '${icon.codePoint},${icon.fontFamily}';
  }

  Future<void> selectIcon(BuildContext context) async {
    IconData? selectedIcon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino],
        // You can change the icon pack mode here
        iconSize: 40,
        barrierDismissible: false,
        closeChild: Text('Close'),
        // Optional, this will add a close button instead of an outside touch event to close the dialog
        searchHintText: 'Search icon...',
        noResultsText: 'No results for your query');

    if (selectedIcon != null) {
      pickicon = selectedIcon;
      update();
    }
  }

  Future<void> fetchCategories() async {
    try {
      List<Category> fetchedCategories = await firebaseService
          .fetchCategories();
      List<Category> mergedCategories = [...defaultExpenseCategories, ...defaultIncomeCategories, ...fetchedCategories];

      Map<String, List<Category>> groupedCategories = {};
      mergedCategories .forEach((category) {
        if (!groupedCategories.containsKey(category.type)) {
          groupedCategories[category.type] = [];
        }
        groupedCategories[category.type]!.add(category);
      });

      categories =groupedCategories;
      update();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
}


