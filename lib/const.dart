import 'package:flutter/material.dart';

const kBackground= Color(0xfff1f4fb);
const kButtonColor= Color(0xffdf4a32);
const kTitleTextStyle = TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold);
const kSubtitleTextStyle = TextStyle(color: Colors.black,fontSize: 16, fontWeight: FontWeight.w400);

const kFont24= TextStyle(fontSize: 20);
const kFont16= TextStyle(fontSize: 16);

String getFontFamily(Locale locale) {
  return (locale.languageCode == 'en') ? 'Roboto' : 'Battambang';
}
