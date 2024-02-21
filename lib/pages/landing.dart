import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_2024/components/app_main_header.dart';
import 'package:flutter_base_2024/constants/styles.dart';
import 'package:flutter_base_2024/controllers/app_controller.dart';
import 'package:flutter_base_2024/utils/common.dart';
import 'package:get/get.dart';

class FooterItem {
  final String title;
  final String route;
  final String? icon;
  final String? activeIcon;
  final Widget components;

  FooterItem({
    required this.components,
    required this.title,
    required this.route,
    this.icon,
    this.activeIcon,
  });
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    // change screen here
    List<FooterItem> footerItems = [
      FooterItem(
        components: _buildDefaultScreen('Home'),
        title: 'Home',
        route: '/home',
        icon: 'lib/assets/images/home_d.png',
        activeIcon: 'lib/assets/images/home.png',
      ),
      FooterItem(
        components: _buildDefaultScreen('Profile'),
        title: 'Profile',
        route: '/profile',
        icon: 'lib/assets/images/profile_d.png',
        activeIcon: 'lib/assets/images/profile.png',
      ),
    ];
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // fixed header here
            const AppMainHeader(height: 150),
            // screen
            Expanded(
              child: Obx(
                () =>
                    footerItems[appController.selectedMainTab.value].components,
              ),
            ),
            // footer
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: footerItems.map((item) {
                  var index = footerItems.indexOf(item);
                  return GestureDetector(
                    onTap: () {
                      appController.onTabChange(index);
                    },
                    child: _buildFooterItem(
                      item.title,
                      item.route,
                      isActive: appController.selectedMainTab.value == index,
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                    ),
                  );
                }).toList(),
              ),
            ),
            addSpace(1),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterItem(
    String title,
    String route, {
    bool isActive = false,
    String? icon,
    String? activeIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          isActive
              ? Bounce(
                  from: 5,
                  child: Image.asset(
                    activeIcon ?? 'lib/assets/images/home.png',
                    width: 24,
                    height: 24,
                  ),
                )
              : Image.asset(
                  icon ?? 'lib/assets/images/home.png',
                  width: 24,
                  height: 24,
                ),
          addSpace(0.2),
          Text(title,
              style: FontStyle.getFont(12).copyWith(
                color: isActive
                    ? AppColor.fontColor
                    : AppColor.fontColor.withOpacity(0.3),
              )),
        ],
      ),
    );
  }

  Widget _buildDefaultScreen(String title) {
    return Scaffold(
      body: Center(
        child: Text(
          title,
          style: FontStyle.getFont(16).copyWith(
            color: AppColor.fontColor,
          ),
        ),
      ),
    );
  }
}
