
import 'package:flutter/material.dart';

class UserProfile {
  final Icon icon;
  final String text;
  final Icon trailIcon;
  // String photo;

  UserProfile({
    required this.icon,
    required this.text,
    required this.trailIcon,
    // required this.photo,
  });


}


List<UserProfile> Listcontact = [
  UserProfile(
      icon: const Icon(Icons.train,color: Colors.amber,),
      text: "Transportation",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.emoji_food_beverage_rounded,color: Colors.amber,),
      text: "Groceries and Food",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.health_and_safety,color: Colors.amber,),
      text: "Healthcare",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.account_box,color: Colors.amber,),
      text: "Entertainment",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.cast_for_education,color: Colors.amber,),
      text: "Education",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.business_sharp,color: Colors.amber,),
      text: "Business Expenses",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.travel_explore,color: Colors.amber,),
      text: "Travel",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
  UserProfile(
      icon: const Icon(Icons.coffee,color: Colors.amber,),
      text: "Coffee",
      trailIcon: const Icon(Icons.arrow_forward_ios)),
];
class PickDate {
  final String text;
  // String photo;
  PickDate({
    required this.text,
    // required this.photo,
  });
}
List<PickDate> pickdate=[
  PickDate(text: 'today'),
  PickDate(text: 'this week'),
  PickDate(text: 'this month'),
  PickDate(text: 'this year'),
  PickDate(text: 'Custom'),
];