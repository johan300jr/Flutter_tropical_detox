import 'package:flutter/material.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackButtonPressed;

  const CustomAppBar2({
    Key? key,
    required this.title,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(216, 27, 26, 26),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onBackButtonPressed ?? () => Navigator.of(context).pop(),
      ),
      title: Text(title),
    );
  }
}