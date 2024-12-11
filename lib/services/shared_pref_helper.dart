import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String userIdKey = "USER_ID_KEY";
  static String userNameKey = "USER_NAME_KEY";
  static String userEmailKey = "USER_EMAIL_KEY";
  static String userWalletKey = "USER_WALLET_KEY";
  static String userProfileKey = "USER_PROFILE_KEY";

  //creating this function to store userId
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userIdKey, getUserId);
  }

  //Creating this function tos store userName
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userNameKey, getUserName);
  }

  //Creating this function to store userEmail
  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userEmailKey, getUserEmail);
  }

  //Creating this function to store userWallet
  Future<bool> saveUserWallet(String getUserWallet) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userWalletKey, getUserWallet);
  }

  Future<bool> saveUserProfile(String getUserprofile) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(userProfileKey, getUserprofile);
  }

  //Creating this function to get userName
  Future<String?> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userIdKey);
  }

  //Creating this function to get userName
  Future<String?> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userNameKey);
  }

  //Creating this function to get userEmail
  Future<String?> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userEmailKey);
  }

  //Creating this function to get userWallet
  Future<String?> getUserWallet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userWalletKey);
  }

  Future<String?> getUserprofile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(userProfileKey);
  }
}
