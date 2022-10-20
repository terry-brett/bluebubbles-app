import 'package:bluebubbles/utils/general_utils.dart';
import 'package:bluebubbles/app/wrappers/stateful_boilerplate.dart';
import 'package:bluebubbles/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:get/get.dart';

class InitialWidgetRight extends StatefulWidget {
  const InitialWidgetRight({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitialWidgetRightState();
}

class _InitialWidgetRightState extends OptimizedState<InitialWidgetRight> {
  Color get backgroundColor => ss.settings.windowEffect.value == WindowEffect.disabled
      ? context.theme.colorScheme.background
      : Colors.transparent;

  @override
  void initState() {
    super.initState();
    // update widget when background color changes
    if (kIsDesktop) {
      ss.settings.windowEffect.listen((WindowEffect effect) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          child: Text(
            "Select a chat from the list",
            style: context.theme.textTheme.bodyLarge
          )
        ),
      ),
    );
  }
}
