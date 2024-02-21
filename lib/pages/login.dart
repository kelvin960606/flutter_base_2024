import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_2024/components/app_button.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:flutter_base_2024/controllers/app_controller.dart';
import 'package:flutter_base_2024/routers/index.dart';
import 'package:flutter_base_2024/services/storage_service.dart';
import 'package:flutter_base_2024/utils/common.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppController appController = Get.find();
  final StorageService storageService = Get.find();
  int type = 0; // 0 login, 1 register 2 forget password
  int loginType = 0; // 0 username, 1 phone
  bool showPwd = false;
  bool rmbPwd = false;
  double sheetHeight = 0.45;
  bool loginLoading = false;
  bool regLoading = false;
  bool resetLoading = false;
  bool vcodeLoading = false;
  int vcodeCount = 0;

  // Login
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // Quick login
  TextEditingController quickPhoneController = TextEditingController();
  TextEditingController quickCodeController = TextEditingController();

  // Register
  TextEditingController regUsernameController = TextEditingController();
  TextEditingController regPasswordController = TextEditingController();
  TextEditingController regMobileController = TextEditingController();
  TextEditingController regEmailController = TextEditingController();
  TextEditingController regRealNameController = TextEditingController();

  // Forget password
  TextEditingController forgetVCodeController = TextEditingController();
  TextEditingController forgetUsernameController = TextEditingController();
  TextEditingController forgetInfoController = TextEditingController();
  TextEditingController forgetPasswordController = TextEditingController();
  TextEditingController forgetConfirmPasswordController =
      TextEditingController();

  void setLoading(bool value) {
    setState(() {
      loginLoading = value;
    });
  }

  void setRegLoading(bool value) {
    setState(() {
      regLoading = value;
    });
  }

  void setRepwdLoading(bool value) {
    setState(() {
      resetLoading = value;
    });
  }

  void setVCodeLoading(bool value) {
    setState(() {
      vcodeLoading = value;
    });
  }

  void setVCount(int value) {
    setState(() {
      vcodeCount = value;
    });
  }

  void quickLogin() {
    if (loginLoading) {
      return;
    }
    if (quickPhoneController.text.isEmpty) {
      EasyLoading.showToast('请输入手机号');
      return;
    }
    if (quickCodeController.text.isEmpty) {
      EasyLoading.showToast('请输入验证码');
      return;
    }
    setLoading(true);
    // handle login request
    Future.delayed(const Duration(seconds: 2), () {
      setLoading(false);
    });
  }

  void login() {
    if (loginType == 1) {
      quickLogin();
      return;
    }
    if (loginLoading) {
      return;
    }
    if (usernameController.text.isEmpty) {
      EasyLoading.showToast('请输入用户名');
      return;
    }
    if (passwordController.text.isEmpty) {
      EasyLoading.showToast('请输入密码');
      return;
    }
    setLoading(true);
    if (!rmbPwd) {
      // if not remember password, clear storage
      storageService.saveLoginInfo(null, null);
    }
    // handle login request
    Future.delayed(const Duration(seconds: 2), () {
      setLoading(false);
      Get.toNamed(Routes.landing);
    });
  }

  void register() {
    if (regUsernameController.text.isEmpty) {
      EasyLoading.showToast('请输入用户名');
      return;
    }
    if (regPasswordController.text.isEmpty) {
      EasyLoading.showToast('请输入密码');
      return;
    }
    if (regMobileController.text.isEmpty) {
      EasyLoading.showToast('请输入手机号');
      return;
    }
    if (regEmailController.text.isEmpty) {
      EasyLoading.showToast('请输入邮箱');
      return;
    }
    if (regRealNameController.text.isEmpty) {
      EasyLoading.showToast('请输入真实姓名');
      return;
    }
    setRegLoading(true);
    // handle register request
    Future.delayed(const Duration(seconds: 2), () {
      setLoading(false);
    });
  }

  void sendOTP() {
    if (vcodeLoading) {
      return;
    }
    if (vcodeCount > 0) {
      EasyLoading.showToast('请在$vcodeCount秒后再试');
      return;
    }
    if (forgetUsernameController.text.isEmpty) {
      EasyLoading.showToast('请输入用户名');
      return;
    }
    if (forgetInfoController.text.isEmpty) {
      EasyLoading.showToast('请输入手机号/邮箱');
      return;
    }
    setVCodeLoading(true);
    // handle otp request
    Future.delayed(const Duration(seconds: 2), () {
      setVCodeLoading(false);
    });
  }

  void startVCodeTimer() {
    setVCount(120);
    // count down timer
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (vcodeCount <= 0) {
        timer.cancel();
      } else {
        setVCount(vcodeCount - 1);
      }
    });
  }

  void resetPassword() {
    if (resetLoading) {
      return;
    }
    if (forgetUsernameController.text.isEmpty) {
      EasyLoading.showToast('请输入用户名');
      return;
    }
    if (forgetInfoController.text.isEmpty) {
      EasyLoading.showToast('请输入手机号/邮箱');
      return;
    }
    if (forgetVCodeController.text.isEmpty) {
      EasyLoading.showToast('请输入验证码');
      return;
    }
    if (forgetPasswordController.text.isEmpty) {
      EasyLoading.showToast('请输入新密码');
      return;
    }
    if (forgetConfirmPasswordController.text.isEmpty) {
      EasyLoading.showToast('请输入确认密码');
      return;
    }
    if (forgetPasswordController.text != forgetConfirmPasswordController.text) {
      EasyLoading.showToast('两次密码不一致');
      return;
    }

    setRepwdLoading(true);
    // handle reset request
    Future.delayed(const Duration(seconds: 2), () {
      setRepwdLoading(false);
    });
  }

  void clearRegForm() {
    regUsernameController.clear();
    regPasswordController.clear();
    regMobileController.clear();
    regEmailController.clear();
    regRealNameController.clear();
  }

  void clearLoginForm() {
    usernameController.clear();
    passwordController.clear();
    quickPhoneController.clear();
    quickCodeController.clear();
  }

  void clearForgetForm() {
    forgetUsernameController.clear();
    forgetInfoController.clear();
    forgetPasswordController.clear();
    forgetConfirmPasswordController.clear();
  }

  void initForm() {
    storageService.deleteUserToken();
    var userToken = storageService.getUserToken();
    if (userToken != null) {
      Get.offAndToNamed(Routes.landing);
      return;
    }
    clearLoginForm();
    clearRegForm();
    clearForgetForm();
    var loginInfo = storageService.getLoginInfo();
    if (loginInfo != null) {
      if (loginInfo['username'] != null && loginInfo['password'] != null) {
        rmbPwd = true;
      }
      usernameController.text = loginInfo['username'] ?? '';
      passwordController.text = loginInfo['password'] ?? '';
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              'lib/assets/images/bg1.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
            //  login form
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height *
                  (type == 0 ? sheetHeight : 1),
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  height:
                      MediaQuery.of(context).size.height * (1 - sheetHeight),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // tabs
                      _buildTabs(),
                      const Divider(
                        color: AppColor.divider,
                        height: 1,
                        thickness: 0.1,
                      ),
                      addSpace(1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                        ),
                        child: Column(
                          children: [
                            loginType == 0
                                ? TextFormField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      isDense: true,
                                      hintText: '请输入用户名',
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.divider,
                                          width: 0.1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelStyle: FontStyle.getFont(14),
                                      hintStyle: FontStyle.getFont(14).copyWith(
                                        color:
                                            AppColor.fontColor.withOpacity(0.3),
                                      ),
                                    ),
                                  )
                                : TextFormField(
                                    controller: quickPhoneController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      isDense: true,
                                      hintText: '手机号',
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.divider,
                                          width: 0.1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelStyle: FontStyle.getFont(14),
                                      hintStyle: FontStyle.getFont(14).copyWith(
                                        color:
                                            AppColor.fontColor.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                            addSpace(1),
                            loginType == 0
                                ? TextFormField(
                                    controller: passwordController,
                                    obscureText: !showPwd,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      isDense: true,
                                      hintText: '密码',
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.divider,
                                          width: 0.1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelStyle: FontStyle.getFont(14),
                                      hintStyle: FontStyle.getFont(14).copyWith(
                                        color:
                                            AppColor.fontColor.withOpacity(0.3),
                                      ),
                                      suffix: InkWell(
                                        onTap: () {
                                          setState(() {
                                            showPwd = !showPwd;
                                          });
                                        },
                                        child: Image.asset(
                                          !showPwd
                                              ? 'lib/assets/images/pwd_hide.png'
                                              : 'lib/assets/images/pwd_unhide.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  )
                                : TextFormField(
                                    controller: quickCodeController,
                                    obscureText: !showPwd,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      isDense: true,
                                      hintText: '验证码',
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.divider,
                                          width: 0.1,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1,
                                        ),
                                      ),
                                      labelStyle: FontStyle.getFont(14),
                                      hintStyle: FontStyle.getFont(14).copyWith(
                                        color:
                                            AppColor.fontColor.withOpacity(0.3),
                                      ),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 50, minHeight: 35),
                                      suffixIcon: _buildVCodeButton(),
                                    ),
                                  ),
                            addSpace(1),
                            Row(
                              children: [
                                if (loginType == 0)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        rmbPwd = !rmbPwd;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColor.fontColor
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: rmbPwd
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 12,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ),
                                        addWidthSpace(0.5),
                                        Text(
                                          '记住密码',
                                          style: FontStyle.getFont(12),
                                        ),
                                      ],
                                    ),
                                  ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      type = 2;
                                    });
                                  },
                                  child: Text(
                                    '忘记密码',
                                    style: FontStyle.getFont(12),
                                  ),
                                ),
                              ],
                            ),
                            addSpace(1),
                            // login button
                            AppButton(
                              label: '登入',
                              isLoading: loginLoading,
                              fontColor: Colors.white,
                              onPressed: () {
                                login();
                              },
                            ),
                            addSpace(1),
                            AppButton(
                              label: '注册',
                              bgColor: Colors.white,
                              onPressed: () {
                                clearLoginForm();
                                setState(() {
                                  type = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // register form
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height *
                  (type == 1 ? sheetHeight : 1),
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  height:
                      MediaQuery.of(context).size.height * (1 - sheetHeight),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      addSpace(1),
                      Text(
                        '注册',
                        style: FontStyle.getFont(16, weight: FontWeight.w700),
                      ),
                      addSpace(1),
                      const Divider(
                        color: AppColor.divider,
                        height: 1,
                        thickness: 0.1,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding * 2,
                          ),
                          child: Column(
                            children: [
                              addSpace(1),
                              TextFormField(
                                controller: regUsernameController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  isDense: true,
                                  hintText: '用户名',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.divider,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  labelStyle: FontStyle.getFont(14),
                                  hintStyle: FontStyle.getFont(14).copyWith(
                                    color: AppColor.fontColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              addSpace(1),
                              TextFormField(
                                controller: regPasswordController,
                                obscureText: !showPwd,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  isDense: true,
                                  hintText: '密码',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.divider,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  labelStyle: FontStyle.getFont(14),
                                  hintStyle: FontStyle.getFont(14).copyWith(
                                    color: AppColor.fontColor.withOpacity(0.3),
                                  ),
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPwd = !showPwd;
                                      });
                                    },
                                    child: Image.asset(
                                      !showPwd
                                          ? 'lib/assets/images/pwd_hide.png'
                                          : 'lib/assets/images/pwd_unhide.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                              ),
                              addSpace(1),
                              TextFormField(
                                controller: regRealNameController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  isDense: true,
                                  hintText: '真实姓名',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.divider,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  labelStyle: FontStyle.getFont(14),
                                  hintStyle: FontStyle.getFont(14).copyWith(
                                    color: AppColor.fontColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              addSpace(1),
                              TextFormField(
                                controller: regMobileController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  isDense: true,
                                  hintText: '手机号',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.divider,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  labelStyle: FontStyle.getFont(14),
                                  hintStyle: FontStyle.getFont(14).copyWith(
                                    color: AppColor.fontColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              addSpace(1),
                              TextFormField(
                                controller: regEmailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10),
                                  isDense: true,
                                  hintText: '邮箱',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.divider,
                                      width: 0.1,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColor.primaryColor,
                                      width: 1,
                                    ),
                                  ),
                                  labelStyle: FontStyle.getFont(14),
                                  hintStyle: FontStyle.getFont(14).copyWith(
                                    color: AppColor.fontColor.withOpacity(0.3),
                                  ),
                                ),
                              ),

                              addSpace(2),
                              // submit button
                              AppButton(
                                label: '提交',
                                bgColor: Colors.white,
                                onPressed: () {
                                  register();
                                },
                              ),

                              addSpace(1.5),
                              InkWell(
                                onTap: () {
                                  clearRegForm();
                                  setState(() {
                                    type = 0;
                                  });
                                },
                                child: Text(
                                  '已有账号？ 请登入',
                                  style: FontStyle.getFont(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // forget password form
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height *
                  (type == 2 ? sheetHeight : 1),
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  height:
                      MediaQuery.of(context).size.height * (1 - sheetHeight),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      addSpace(1),
                      Text(
                        '忘记密码',
                        style: FontStyle.getFont(16, weight: FontWeight.w700),
                      ),
                      addSpace(1),
                      const Divider(
                        color: AppColor.divider,
                        height: 1,
                        thickness: 0.1,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding * 2,
                        ),
                        child: Column(
                          children: [
                            addSpace(1),
                            TextFormField(
                              controller: forgetUsernameController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                isDense: true,
                                hintText: '用户名',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.divider,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                labelStyle: FontStyle.getFont(14),
                                hintStyle: FontStyle.getFont(14).copyWith(
                                  color: AppColor.fontColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            addSpace(1),
                            TextFormField(
                              controller: forgetInfoController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                isDense: true,
                                hintText: '手机号/邮箱账号',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.divider,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                labelStyle: FontStyle.getFont(14),
                                hintStyle: FontStyle.getFont(14).copyWith(
                                  color: AppColor.fontColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            addSpace(1),
                            TextFormField(
                              controller: forgetVCodeController,
                              obscureText: !showPwd,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                isDense: true,
                                hintText: '验证码',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.divider,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                labelStyle: FontStyle.getFont(14),
                                hintStyle: FontStyle.getFont(14).copyWith(
                                  color: AppColor.fontColor.withOpacity(0.3),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                    minWidth: 50, minHeight: 35),
                                suffixIcon: _buildVCodeButton(),
                              ),
                            ),
                            addSpace(1),
                            TextFormField(
                              controller: forgetPasswordController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                isDense: true,
                                hintText: '新密码',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.divider,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                labelStyle: FontStyle.getFont(14),
                                hintStyle: FontStyle.getFont(14).copyWith(
                                  color: AppColor.fontColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            addSpace(1),
                            TextFormField(
                              controller: forgetConfirmPasswordController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10),
                                isDense: true,
                                hintText: '确认新密码',
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.divider,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                labelStyle: FontStyle.getFont(14),
                                hintStyle: FontStyle.getFont(14).copyWith(
                                  color: AppColor.fontColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            addSpace(1.5),
                            // submit button
                            AppButton(
                              label: '提交',
                              isLoading: resetLoading,
                              bgColor: Colors.white,
                              onPressed: () {
                                resetPassword();
                              },
                            ),

                            addSpace(1.5),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  type = 0;
                                });
                              },
                              child: Text(
                                '返回',
                                style: FontStyle.getFont(12),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVCodeButton() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            sendOTP();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: vcodeCount > 0 ? 40 : 100,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: vcodeCount > 0
                    ? AppColor.fontColor.withOpacity(0.6)
                    : AppColor.primaryColor,
                width: vcodeCount > 0 ? 0.1 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              vcodeCount > 0 ? '$vcodeCount' : '发送验证码',
              style: FontStyle.getFont(12).copyWith(
                color: vcodeCount > 0
                    ? AppColor.fontColor.withOpacity(0.3)
                    : AppColor.primaryColor,
              ),
            ),
          ),
        ),
        addSpace(0.5),
      ],
    );
  }

  Container _buildTabs() {
    return Container(
      padding: addPadding(0.5, 0, 0, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                clearLoginForm();
                setState(() {
                  loginType = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 100),
                  style: FontStyle.getFont(
                    14,
                    weight: loginType == 0 ? FontWeight.w700 : FontWeight.w400,
                  ).copyWith(
                    color: loginType == 0
                        ? AppColor.fontColor
                        : AppColor.fontColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    '用户名登入',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
            child: VerticalDivider(
              color: AppColor.divider,
              width: 1,
              thickness: 0.1,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                clearLoginForm();
                setState(() {
                  loginType = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 100),
                  style: FontStyle.getFont(14,
                          weight: loginType == 1
                              ? FontWeight.w700
                              : FontWeight.w400)
                      .copyWith(
                    color: loginType == 1
                        ? AppColor.fontColor
                        : AppColor.fontColor.withOpacity(0.3),
                  ),
                  child: const Text(
                    '手机号码登入',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
