import 'package:flutter/material.dart';

import '../../../../consts.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text(
          "Activity",
          style: TextStyle(color: primaryColor),
        ),
      ),
    );
  }
}
