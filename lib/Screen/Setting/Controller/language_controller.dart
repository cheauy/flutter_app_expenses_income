
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_expenses_income/Screen/Setting/Controller/language_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class Language {
 final String lang;
 final AssetImage image;

  Language({required this.lang, required this.image});
}

class LanguageController extends GetxController{
  var isselectIndex = 0;
  final LangService langService = LangService();
  final storage = GetStorage();
  final indexKey = 'SelectedIndex';
  final key = 'LangCode';
  final List<Language> languages = [
   Language(lang: 'English (US)', image: AssetImage('assets/images/american.png')),
    Language(lang: 'ភាសាខ្មែរ', image: AssetImage('assets/images/cambodia.png')),
  ];
  @override
  void onInit() {
    super.onInit();

    setInitialLanguage();
  }
  void setInitialLanguage() async {
    isselectIndex = readIndex(); // Read the saved index from storage
    changeLocale(isselectIndex);
  }

  Future<void> writeKey(String langCode) async {
    await storage.write(key, langCode);
  }

  Future<void> writeIndex(int index) async {
    await storage.write(indexKey, index);
  }

  void changeLocale(int index) async {
    final selectedLocale = index == 0 ? 'en' : 'km';
    Locale locale = Locale(selectedLocale);
    Get.updateLocale(locale);
    await writeKey(selectedLocale);
    await writeIndex(index);
    update();
  }

  void selectIndex(int index) {
    isselectIndex = index;
    changeLocale(index);
    update();
  }

  void resetIndex() {
    isselectIndex = readIndex(); // Reset to default index
    update();
  }

  String readKey() {
    return storage.read(key) ?? 'en';
  }

  int readIndex() {
    return storage.read(indexKey) ?? 0;
  }

  Locale getLanguageIndex() {
    String langcode = readKey();
    switch (langcode) {
      case 'en':
        {
          return const Locale('en', 'US');
        }

      case 'km':
        {
          return const Locale('km', 'KH');
        }

      default:
        {
          return const Locale('en', 'US');
        }
    }
  }

  String getCurrentLanguage() {
    return languages[isselectIndex].lang;

  }
}
