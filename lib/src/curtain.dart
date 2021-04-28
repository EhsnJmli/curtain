import 'package:curtain/curtain.dart';
import 'package:curtain/src/curtain_item.dart';
import 'package:curtain/src/config.dart';
import 'package:curtain/src/side_bar/side_bar.dart';
import 'package:flutter/material.dart';

class Curtain extends StatefulWidget {
  const Curtain({
    required this.items,
    this.curtainSideBarConfig,
    this.initialPage = 0,
    this.extendBody = false,
    this.onPageChange,
    this.scaffoldConfig,
    this.direction,
  }) : assert(items.length > 0);

  /// Items of the curtain.
  ///
  /// each item contains an action and a page which are connected to each other.
  final List<CurtainItem> items;

  /// Config of the [CurtainSideBar].
  final CurtainSideBarConfig? curtainSideBarConfig;

  /// Initial page of the curtain.
  final int initialPage;

  /// If true, page will be extend under the edge of the selected action if its not zero.
  ///
  /// You can define offset of the edge of selected action in [selectedActionXOffset] in [CurtainSideBarConfig].
  ///
  /// defaults to false.
  final bool extendBody;

  /// Called with page index when page changed.
  final void Function(int page)? onPageChange;

  /// Config of the scaffold of the main page.
  final ScaffoldConfig? scaffoldConfig;

  /// Directionality of the page.
  ///
  /// If sets on null, it will get the directionality of its context.
  final TextDirection? direction;

  @override
  _CurtainState createState() => _CurtainState();
}

class _CurtainState extends State<Curtain> {
  late int pageIndex;
  late ScaffoldConfig _config;
  late CurtainSideBarConfig _curtainSideBarConfig;

  @override
  void initState() {
    super.initState();
    _config = widget.scaffoldConfig ?? ScaffoldConfig();
    _curtainSideBarConfig =
        widget.curtainSideBarConfig ?? CurtainSideBarConfig();
    pageIndex = widget.initialPage;
  }

  void changeIndex(int index) {
    if (widget.onPageChange != null) widget.onPageChange!(index);
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final directionality = widget.direction ?? Directionality.of(context);
    final isLtr = directionality == TextDirection.ltr;
    final sideBar = CurtainSideBar(
      direction: directionality,
      index: pageIndex,
      config: widget.curtainSideBarConfig,
      actions: widget.items.map((item) => item.action).toList(),
      changeIndex: changeIndex,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth < 800;
        final isMobile = constraints.maxWidth < 400;
        final persistentWidget = widget.scaffoldConfig!.persistentWidget;
        final sideBarWidth = _curtainSideBarConfig.width -
            (widget.extendBody
                ? _curtainSideBarConfig.selectedActionXOffset
                : 0);
        return Scaffold(
          appBar: isTablet
              ? _config.mobileAppBar ??
                  AppBar(
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                  )
              : null,
          extendBodyBehindAppBar: _config.extendBodyBehindAppBar,
          backgroundColor: _config.backgroundColor,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Row(
                children: [
                  if (!isTablet)
                    SizedBox(
                      width: sideBarWidth,
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        if (persistentWidget != null &&
                            ((isMobile && persistentWidget.showInMobile) ||
                                (isTablet && persistentWidget.showInTablet) ||
                                (!isTablet && persistentWidget.showInWeb)))
                          Align(
                            alignment: persistentWidget.alignment,
                            child: persistentWidget.child,
                          ),
                        Positioned.fill(
                          child: widget.items
                              .map((item) => item.page)
                              .toList()[pageIndex],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (!isTablet)
                Positioned(
                  right: isLtr ? null : 0,
                  left: isLtr ? 0 : null,
                  child: sideBar,
                ),
            ],
          ),
          drawer: isTablet ? sideBar : null,
          drawerDragStartBehavior: _config.drawerDragStartBehavior,
          drawerEdgeDragWidth: _config.drawerEdgeDragWidth,
          drawerEnableOpenDragGesture: _config.drawerEnableOpenDragGesture,
          drawerScrimColor: _config.drawerScrimColor,
          endDrawer: _config.endDrawer,
          endDrawerEnableOpenDragGesture:
              _config.endDrawerEnableOpenDragGesture,
          key: _config.key,
          floatingActionButton: _config.floatingActionButton,
          floatingActionButtonLocation: _config.floatingActionButtonLocation,
          floatingActionButtonAnimator: _config.floatingActionButtonAnimator,
          bottomSheet: _config.bottomSheet,
          persistentFooterButtons: _config.persistentFooterButtons,
          resizeToAvoidBottomInset: _config.resizeToAvoidBottomInset,
          primary: _config.primary,
        );
      },
    );
  }
}
