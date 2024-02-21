import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
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

  // change screen here
  List<FooterItem> footerItems = [
    FooterItem(
      components: Container(),
      title: '广场',
      route: '/home',
      icon: 'lib/assets/images/home_d.png',
      activeIcon: 'lib/assets/images/home.png',
    ),
    FooterItem(
      components: Container(),
      title: '游戏',
      route: '/game',
      icon: 'lib/assets/images/game_d.png',
      activeIcon: 'lib/assets/images/game.png',
    ),
    FooterItem(
      components: Container(),
      title: '客服',
      route: '/chat',
      icon: 'lib/assets/images/cs_d.png',
      activeIcon: 'lib/assets/images/cs.png',
    ),
    FooterItem(
      components: Container(),
      title: '优惠',
      route: '/promotion',
      icon: 'lib/assets/images/promo_d.png',
      activeIcon: 'lib/assets/images/promo.png',
    ),
    FooterItem(
      components: Container(),
      title: '我的',
      route: '/profile',
      icon: 'lib/assets/images/profile_d.png',
      activeIcon: 'lib/assets/images/profile.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // fixed header here
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
}
