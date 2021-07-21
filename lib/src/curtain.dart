import 'package:curtain/curtain.dart';
import 'package:curtain/src/curtain_item.dart';
import 'package:curtain/src/config.dart';
import 'package:curtain/src/curtain_page_controller.dart';
import 'package:curtain/src/side_bar/side_bar.dart';
import 'package:flutter/material.dart';

class Curtain extends StatefulWidget {
  const Curtain({
    required this.items,
    this.curtainSideBarConfig,
    this.extendBody = false,
    this.onPageChange,
    this.scaffoldConfig,
    this.direction,
    this.controller,
  }) : assert(items.length > 0);

  /// Items of the curtain.
  ///
  /// each item contains an action and a page which are connected to each other.
  final List<CurtainItem> items;

  /// Config of the [CurtainSideBar].
  final CurtainSideBarConfig? curtainSideBarConfig;

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

  /// An object that can be used to control the curtain page.
  final CurtainPageController? controller;

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
    pageIndex = widget.controller != null ? widget.controller!.initialPage : 0;
    if (widget.controller != null) {
      widget.controller!.addListener(pageListener);
    }
  }

  @override
  void didUpdateWidget(covariant Curtain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scaffoldConfig != null) {
      _config = widget.scaffoldConfig!;
    }
    if (widget.curtainSideBarConfig != null) {
      _curtainSideBarConfig = widget.curtainSideBarConfig!;
    }
    if (oldWidget.controller == null && widget.controller != null) {
      widget.controller!.addListener(pageListener);
    }
  }

  void pageListener() {
    assert(
        widget.controller!.page < widget.items.length &&
            widget.controller!.page >= 0,
        "Page is not in range!");
    if (widget.controller!.page != pageIndex) {
      changeIndex(widget.controller!.page);
    }
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
      changeIndex: widget.controller != null
          ? (newIndex) {
              widget.controller!.goToPage(newIndex);
            }
          : changeIndex,
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
                        Positioned.fill(
                          child: Padding(
                            padding: _config.pagePadding,
                            child: widget.items
                                .map((item) => item.page)
                                .toList()[pageIndex],
                          ),
                        ),
                        if (persistentWidget != null &&
                            ((isMobile && persistentWidget.showInMobile) ||
                                (isTablet && persistentWidget.showInTablet) ||
                                (!isTablet && persistentWidget.showInWeb)))
                          Align(
                            alignment: persistentWidget.alignment,
                            child: persistentWidget.child,
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

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(pageListener);
    }
    super.dispose();
  }
}
