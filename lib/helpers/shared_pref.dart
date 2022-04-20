import 'dart:convert';

import 'package:hiinternet/login_screen/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SharedPref with ChangeNotifier{

  // keys!
  static const token = 'token';
  static const account ='account';
  static const payment ='payment';
  static const user_id ='user_id';
  static const user_phone ='user_phone';
  static const home ='home';
  static const complain_ticket ='complain_ticket';
  static const complain_category ='complain_category';
  static const language_status ='language_status';
  static const payment_method_url = 'payment_method_url';
  static const create_user_status = 'create_user_status';

  static String cache_selected_language = "ENG";

 static Future<bool> setData(String key,String value) async{
   if(key == language_status){
     cache_selected_language = value;
   }

   SharedPreferences shp = await SharedPreferences.getInstance();
   return shp.setString(key, value);
 }
 
 static Future<String> getData({@required String key})  async {
   SharedPreferences shp = await SharedPreferences.getInstance();
   String result = shp.getString(key);

   if(key == language_status){
     cache_selected_language = result;
   }

   return result;
 }

 static bool IsSelectedEng() {
   return (cache_selected_language == "ENG");
 }

 static void clear() async{
   SharedPreferences shp = await SharedPreferences.getInstance();
   shp.clear();
 }

}