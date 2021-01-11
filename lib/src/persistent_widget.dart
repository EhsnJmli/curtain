import 'package:curtain/curtain.dart';
import 'package:flutter/material.dart';

class PersistentWidget {
  const PersistentWidget({
    @required this.child,
    this.alignment = Alignment.topRight,
    this.showInWeb = true,
    this.showInTablet = false,
    this.showInMobile = false,
  })  : assert(child != null),
        assert(alignment != null),
        assert(showInWeb != null),
        assert(showInTablet != null),
        assert(showInMobile != null);

  /// Child of Persistent widget.
  final Widget child;

  /// Alignment of persistent widget in [Curtain] main page.
  ///
  /// defaults to [Alignment.topRight].
  final AlignmentGeometry alignment;

  /// Should show [child] in web.
  ///
  /// defaults to true.
  final bool showInWeb;

  /// Should show [child] in tablet.
  ///
  /// defaults to false.
  final bool showInTablet;

  /// Should show [child] in mobile.
  ///
  /// defaults to false.
  final bool showInMobile;
}
