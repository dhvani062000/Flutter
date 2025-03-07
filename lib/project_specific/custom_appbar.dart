import 'package:flutter/material.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showIcons;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    required this.title,
    this.showIcons = true,
    this.onSearchTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true ,
      automaticallyImplyLeading: false,
      title: Text(title,style: AppTextTheme.black.copyWith(color: ColorConstant.primary,fontSize: 22),),
      actions: showIcons
          ? [
        IconButton(icon: const Icon(Icons.search), onPressed: onSearchTap),
        IconButton(icon: const Icon(Icons.notifications), onPressed: onNotificationTap),
        IconButton(icon: const Icon(Icons.person), onPressed: onProfileTap),
      ]
          : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
