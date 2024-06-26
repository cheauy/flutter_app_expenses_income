import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/category_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/darkmode_controller.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/add_category.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/cate_model.dart';
import 'package:flutter_app_expenses_income/const.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {


  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final DarkmodeController darkmodeController = Get.put(DarkmodeController());
  final CategoryController categoryController = Get.put(CategoryController());
  String fontFamily = getFontFamily(Get.locale!);
  void showDeletAlert(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('alert message'.tr),
        actions: <Widget>[
          TextButton(
              child: Text('yes'.tr),
              onPressed: ()  {

                categoryController.deleteTran(category.id!);
                categoryController.fetchCategories();
                Get.back();


              }
          ),
          TextButton(
            child: Text('no'.tr),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'category'.tr,
          style: TextStyle(fontFamily: fontFamily,fontSize: 24,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => AddCategory(),
                    transition: Transition.leftToRightWithFade);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: GetBuilder<CategoryController>(
          init: CategoryController(),
          builder: (controller) {


            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                      decoration: InputDecoration(
                    fillColor: darkmodeController.isDarkMode ? Colors.grey.withOpacity(0.1) : Colors.grey[200],
                    filled: true,
                    hintStyle: TextStyle(fontFamily: fontFamily,fontWeight: FontWeight.bold),
                    hintText: 'Search'.tr,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                  )),
                  SizedBox(
                    height: 20,
                  ),

                  Expanded(
                      child: ListView.builder(
                        itemCount: controller.categories.length,
                        itemBuilder: (context,index){
                          final type = controller.categories.keys.toList()[index];
                          final category = controller.categories[type]!;
                          return  ExpansionTile(
                            leading: Icon(Icons.import_contacts,color: darkmodeController.isDarkMode ? Colors.white : Colors.black,),
                            title: Text(type.tr,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,fontFamily: fontFamily),),
                            collapsedIconColor: darkmodeController.isDarkMode ? Colors.white : Colors.black,
                            iconColor: darkmodeController.isDarkMode ? Colors.white : Colors.black,
                            children: category.map((category){
                              IconData iconData = getIconFromString(category.icon);
                            return  Slidable(
                              enabled: category.isCustom,
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: BehindMotion(),
                                children: [
                                  Spacer(flex: 3,),
                                  InkWell(
                                    onTap: ()=>showDeletAlert(context,category),
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Icon(Icons.delete,color: Colors.white,)
                                    ),
                                  ),
                                  Spacer(flex: 2,),

                                ],
                              ),
                              child: ListTile(
                                  leading: category.isCustom ? Icon(iconData,color: Colors.amber,) : Icon(category.iconDefualt,color: Colors.amber,) ,
                                  title: Text(category.name.tr, style: TextStyle(fontFamily: fontFamily,fontSize: 16,fontWeight: FontWeight.bold)),
                                  trailing:category.isCustom ? Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10)),

                                    height:25,
                                    width :50,
                                    child: Text('Custom',style: TextStyle(color: Colors.white),),):  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)),
                                    height:25,
                                    width :50,
                                    child: Text('Default',style: TextStyle(color: Colors.white),),)

                                ),
                            );
                            }).toList(),


                          );
                      }

                  ))
                ],
              ),
            );
          }),
    );
  }
}
List<Widget> _buildCategoryList(List<Category> categories) {
  return categories.map((category) {
    return ListTile(
     // leading: Icon(getIconData(category.icon)),
      title: Text(category.name),
      trailing: Text(category.type),
    );
  }).toList();
}



