import 'package:curtain/curtain.dart';
import 'package:curtain/src/side_bar/side_bar.dart';
import 'package:flutter/material.dart';

class CurtainAction {
  const CurtainAction({
    @required this.icon,
    @required this.text,
    this.color,
    this.selectedColor,
    this.height = 50,
    this.borderRadius ,
  })  : assert(icon != null),
        assert(text != null),
        assert(height != null);

  /// Displayed icon of the action.
  final Icon icon;

  /// Text of the action always displayed in mobile drawer
  /// and displayed in web when [CurtainSideBar] is expanded.
  final Text text;

  /// Icon and text color when action is not selected.
  ///
  /// When its value sets on null it will use the [itemsBackgroundColor]
  /// which defined in [CurtainSideBarConfig] as its default value.
  final Color color;

  /// Icon and text color when action is selected.
  ///
  /// When its value sets on null it will use the [itemsSelectedBackgroundColor]
  /// which defined in [CurtainSideBarConfig] as its default value.
  final Color selectedColor;

  /// Height of the action button in the [CurtainSideBar].
  ///
  /// defaults to 50.
  final double height;

  /// BorderRadius of the action button in the [CurtainSideBar].
  final BorderRadius borderRadius;
}
