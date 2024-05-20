import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String windowName;
  final String pageDescription;
  final VoidCallback? onLogoutPressed;

  const CustomAppBar({
    Key? key,
    required this.windowName,
    required this.pageDescription,
    this.onLogoutPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            windowName,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            pageDescription,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        if (onLogoutPressed != null)
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: onLogoutPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
