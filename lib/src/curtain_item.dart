import 'package:curtain/src/side_bar/action.dart';
import 'package:curtain/src/side_bar/side_bar.dart';
import 'package:flutter/material.dart';

class CurtainItem {
  const CurtainItem({
    @required this.page,
    @required this.action,
  }) : assert(page != null && action != null);

  /// Displayed page when its [action] selected.
  final Widget page;

  /// Action button in the [CurtainSideBar] which represents its [page].
  final CurtainAction action;
}
