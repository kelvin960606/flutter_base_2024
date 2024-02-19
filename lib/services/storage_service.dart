import 'package:flutter_base_2024/constants/storage_key.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class StorageService extends GetxService {
  Box? authBox;
  Box? configBox;
  Box? chatBox;
  Box? userListBox;
  @override
  void onInit() async {
    init();
    super.onInit();
  }

  init() async {
    authBox = await Hive.openBox('authBox');
    configBox = await Hive.openBox('configBox');
    chatBox = await Hive.openBox('chatBox');
    userListBox = await Hive.openBox('userListBox');
  }

  checkBox() async {
    authBox ??= await Hive.openBox('authBox');
    chatBox ??= await Hive.openBox('chatBox');
    configBox ??= await Hive.openBox('configBox');
    userListBox ??= await Hive.openBox('userListBox');
  }

  saveUserToken(token) {
    checkBox();
    authBox!.put(StorageKey.authToken, token);
  }

  saveIntoUserList(username, password, name) {
    checkBox();
    userListBox!.put(
        username, {'username': username, 'password': password, 'name': name});
  }

  Map getUserList() {
    checkBox();
    return userListBox!.toMap();
  }

  removeUserFromList(username) {
    checkBox();
    userListBox!.delete(username);
  }

  String? getUserToken() {
    checkBox();
    return authBox!.get(StorageKey.authToken);
  }

  deleteUserToken() {
    checkBox();
    authBox!.delete(StorageKey.authToken);
  }

  saveRefreshToken(token) {
    checkBox();
    authBox!.put(StorageKey.refreshToken, token);
  }

  String? getRefreshToken() {
    checkBox();
    return authBox!.get(StorageKey.refreshToken);
  }

  deleteRefreshToken() {
    checkBox();
    authBox!.delete(StorageKey.refreshToken);
  }

  saveBaseToken(token) {
    checkBox();
    authBox!.put(StorageKey.baseToken, token);
  }

  String? getBaseToken() {
    checkBox();
    return authBox!.get(StorageKey.baseToken);
  }

  saveLangList(list) async {
    checkBox();
    configBox!.put(StorageKey.langList, list);
  }

  getLangList() {
    checkBox();
    return configBox!.get(StorageKey.langList);
  }

  saveLang(l) {
    checkBox();
    configBox!.put(StorageKey.lang, l);
  }

  String? getLang() {
    checkBox();
    return configBox!.get(StorageKey.lang);
  }

  saveCountryList(list) {
    checkBox();
    configBox!.put(StorageKey.countryList, list);
  }

  List? getCountryList() {
    checkBox();
    return configBox!.get(StorageKey.countryList);
  }

  saveConfigList(data) {
    checkBox();
    configBox!.put(StorageKey.configData, data);
  }

  getConfigData() {
    checkBox();
    return configBox!.get(StorageKey.configData);
  }

  saveLoginInfo(username, pwd, {String country = ''}) {
    checkBox();
    authBox!.put('username', username);
    authBox!.put('password', pwd);
  }

  getLoginInfo() {
    checkBox();
    return {
      'username': authBox!.get('username'),
      'password': authBox!.get('password')
    };
  }

  deleteLoginInfo() {
    checkBox();
    authBox!.delete('username');
    authBox!.delete('password');
  }
}
