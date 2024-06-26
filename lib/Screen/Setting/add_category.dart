import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/category_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/category_screen.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:get/get.dart';

class AddCategory extends StatefulWidget {
  AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  Color _currentColor = Colors.blue;
  final controller=Get.put(CategoryController());
  final DarkmodeController darkmodeController=Get.put(DarkmodeController());
  void _onColorChanged(Color color) {
    setState(() {
      _currentColor = color;
    });
  }
  String fontFamily = getFontFamily(Get.locale!);



  List<Color> colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Adds Category',
            style: kFont24,
          ),
          actions: [IconButton(onPressed: (){
            controller.addCategory();
            controller.fetchCategories();
            Get.back();
          }, icon: Icon(Icons.add))],
          centerTitle: true,
        ),
        body: GetBuilder<CategoryController>(
          init: CategoryController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(
                    runSpacing: 5,
                    children: [
                      Text(
                        'Category Name',
                        style: kFont16,
                      ),
                      TextField(
                        controller: controller.nameController,
                          decoration: InputDecoration(
                        hintText: 'Enter Name',
                        filled: true,
                        fillColor: darkmodeController.isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey[300],
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    runSpacing: 5,
                    children: [
                      Text(
                        'Category Name by Khmer',
                        style: kFont16,
                      ),
                      TextField(
                        controller: controller.nameKhController,
                          decoration: InputDecoration(
                        hintText: 'Enter Name by khmer',
                        filled: true,
                        fillColor: darkmodeController.isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey[300],
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Category Type',
                    style: kFont16,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: Get.width,
                      height: Get.height * 0.2,
                      child: GridView.count(
                        // controller: controller.typeController,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        // Number of columns
                        mainAxisSpacing: 10.0,
                        // Spacing between rows
                        crossAxisSpacing: 10.0,
                        // Spacing between columns
                        childAspectRatio: 2.5,
                        // Aspect ratio (width / height) of each item
                        children: List.generate(filter.length, (index) {
              
                          final isSelected = index == controller.selectedIndex;
                          final item = filter[index];
                          return GestureDetector(
                            onTap: () {

                              controller.selectCategory(index);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.amber : darkmodeController.isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  item.icon,
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    item.title.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                        color: isSelected ? Colors.white : null),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Icon',
                    style: kFont16,
                  ),
                  TextField(
                    controller: controller.iconController,
                    onTap: () {
                      controller.selectIcon(context);
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        prefixIcon: controller.pickicon != null ? Icon(controller.pickicon) : null,
                        hintText: controller.pickicon != null ? null : 'Choose icon style',
                        filled: true,
                        fillColor: darkmodeController.isDarkMode ? Colors.grey.withOpacity(0.1): Colors.grey[300],
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        suffixIcon: Icon(Icons.keyboard_arrow_down)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'Colors',
                  //   style: kSubtitleTextStyle,
                  // ),
                  // Container(
                  //   child: SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Row(
                  //         children: List.generate(
                  //             colors.length,
                  //             (index) => Padding(
                  //               padding: const EdgeInsets.only(right: 15,top: 5),
                  //               child: GestureDetector(
                  //                 onTap: ()=> _onColorChanged(colors[index]),
                  //                 child: CircleAvatar(
                  //                       backgroundColor: colors[index],
                  //                   child: _currentColor == colors[index]
                  //                       ? Icon(Icons.check, color: Colors.white)
                  //                       : null,
                  //                     ),
                  //               ),
                  //             )),
                  //       )),
                  // )
                ]),
              ),
            );
          }
        ));
  }
}
