import 'package:flutter/material.dart';

import 'nav.dart';

class SevnNavBar extends StatelessWidget {
  final int activeIndex;
  final List<SevnNav> navs;
  final void Function(int) onTap;

  SevnNavBar({this.activeIndex, this.navs, this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextStyle textStyle = themeData.textTheme.caption;
    return BottomNavigationBar(
      currentIndex: activeIndex,
      items: navs
          .map<BottomNavigationBarItem>(
            (SevnNav nav) => BottomNavigationBarItem(
              activeIcon: Icon(
                nav.icon,
                color: themeData.primaryColor,
                semanticLabel: nav.label,
              ),
              icon: Icon(
                nav.icon,
                color: themeData.primaryIconTheme.color,
                semanticLabel: nav.label,
              ),
              title: Text(
                nav.title,
                style: _isActive(nav)
                    ? textStyle
                        .merge(TextStyle(color: themeData.primaryColorDark))
                    : textStyle,
              ),
            ),
          )
          .toList(),
      onTap: onTap,
      showUnselectedLabels: true,
    );
  }

  bool _isActive(SevnNav nav) => activeIndex == navs.indexOf(nav);
}