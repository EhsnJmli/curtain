import 'dart:ui';

import 'package:curtain/src/config.dart';
import 'package:curtain/src/side_bar/action.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/extensions.dart';

class CurtainSideBar extends StatefulWidget {
  const CurtainSideBar({
    required this.actions,
    required this.index,
    required this.changeIndex,
    required this.direction,
    this.config,
  });

  /// Function to change index of the page when click happens in one item.
  final void Function(int index) changeIndex;

  /// Config of [CurtainSideBar].
  final CurtainSideBarConfig? config;

  /// Current index.
  final int index;

  /// Actions of the [CurtainSideBar].
  final List<CurtainAction> actions;

  /// Directionality of the page.
  final TextDirection direction;

  @override
  _CurtainSideBarState createState() => _CurtainSideBarState();
}

class _CurtainSideBarState extends State<CurtainSideBar> {
  late double _width;
  late CurtainSideBarConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? CurtainSideBarConfig();
    _width = _config.width;
  }

  @override
  void didUpdateWidget(covariant CurtainSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null) {
      _config = widget.config!;
      _width = _config.width;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final isLtr = widget.direction == TextDirection.ltr;
          final isTablet = constraints.maxWidth < 800;
          if (isTablet) _width = _config.expandWidth;
          final isExpand = isTablet || _width == _config.expandWidth;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: !isTablet
                ? (p) {
                    setState(() {
                      _width = _config.expandWidth;
                    });
                  }
                : null,
            onExit: !isTablet
                ? (p) {
                    setState(() {
                      _width = _config.width;
                    });
                  }
                : null,
            child: AnimatedContainer(
              height: MediaQuery.of(context).size.height,
              duration: _config.duration,
              width: _width,
              color: isTablet ? _config.backgroundColor : Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (!isTablet)
                    AnimatedContainer(
                      curve: Curves.easeIn,
                      margin: EdgeInsets.only(
                          left: isLtr ? 0 : _config.selectedActionXOffset,
                          right: isLtr ? _config.selectedActionXOffset : 0),
                      duration: _config.duration,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(-1, 0),
                            spreadRadius: 4,
                            blurRadius: 10,
                          ),
                        ],
                        color: _config.backgroundColor,
                      ),
                    ),
                  Column(
                    children: [
                      if (_config.headerBuilder != null)
                        Padding(
                          padding: EdgeInsets.only(
                              left: isLtr ? 0 : _config.selectedActionXOffset,
                              right: isLtr ? _config.selectedActionXOffset : 0),
                          child: _config.headerBuilder!(isExpand, widget.index),
                        ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, innerConstraints) =>
                              SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: innerConstraints.maxHeight,
                              ),
                              child: Column(
                                mainAxisAlignment: _config.mainAxisAlignment,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(widget.actions.length,
                                    (index) {
                                  return _SideBarActionWidget(
                                    direction: widget.direction,
                                    item: widget.actions[index],
                                    isTablet: isTablet,
                                    width: _width,
                                    isExpand: isExpand,
                                    sideBarConfig: _config,
                                    isSelected: widget.index == index,
                                    onClick: () {
                                      if (isTablet) Navigator.pop(context);
                                      widget.changeIndex(index);
                                    },
                                  );
                                }).space(_config.actionsSpacing, Axis.vertical),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class _SideBarActionWidget extends StatelessWidget {
  const _SideBarActionWidget({
    required this.item,
    required this.onClick,
    required this.sideBarConfig,
    required this.width,
    required this.isExpand,
    required this.isSelected,
    required this.isTablet,
    required this.direction,
  });

  final VoidCallback onClick;
  final CurtainAction item;
  final CurtainSideBarConfig sideBarConfig;
  final bool isSelected;
  final bool isTablet;
  final bool isExpand;
  final double width;
  final TextDirection direction;

  @override
  Widget build(BuildContext context) {
    final isLtr = direction == TextDirection.ltr;
    final givenText = item.text;
    final givenIcon = item.icon;
    var textStyle = givenText.style;
    textStyle = textStyle == null
        ? TextStyle(
            color: isSelected
                ? item.selectedColor ?? sideBarConfig.actionsBackgroundColor
                : item.color ?? sideBarConfig.actionsSelectedBackgroundColor,
          )
        : textStyle.copyWith(
            color: isSelected
                ? item.selectedColor ?? sideBarConfig.actionsBackgroundColor
                : item.color ?? sideBarConfig.actionsSelectedBackgroundColor,
          );
    final text = Text(
      givenText.data!,
      style: textStyle,
      textDirection: givenText.textDirection,
      textAlign: givenText.textAlign,
      locale: givenText.locale,
      key: givenText.key,
      strutStyle: givenText.strutStyle,
      maxLines: givenText.maxLines,
      overflow: TextOverflow.ellipsis,
      semanticsLabel: givenText.semanticsLabel,
      softWrap: givenText.softWrap,
      textHeightBehavior: givenText.textHeightBehavior,
      textScaleFactor: givenText.textScaleFactor,
      textWidthBasis: givenText.textWidthBasis,
    );
    final icon = Icon(
      givenIcon.icon,
      key: givenIcon.key,
      textDirection: givenIcon.textDirection,
      color: isSelected
          ? item.selectedColor ?? sideBarConfig.actionsBackgroundColor
          : item.color ?? sideBarConfig.actionsSelectedBackgroundColor,
      size: givenIcon.size,
      semanticLabel: givenIcon.semanticLabel,
    );
    final iconSize = givenIcon.size ?? IconTheme.of(context).size!;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: item.height,
          margin: EdgeInsets.only(
            right: isLtr
                ? (isTablet || isSelected
                    ? 0
                    : sideBarConfig.selectedActionXOffset)
                : 0,
            left: isLtr
                ? 0
                : (isTablet || isSelected
                    ? 0
                    : sideBarConfig.selectedActionXOffset),
          ),
          decoration: BoxDecoration(
            borderRadius: !isTablet && isSelected
                ? item.borderRadius ??
                    BorderRadius.only(
                      bottomLeft: isLtr ? Radius.zero : Radius.circular(6),
                      topLeft: isLtr ? Radius.zero : Radius.circular(6),
                      topRight: isLtr ? Radius.circular(6) : Radius.zero,
                      bottomRight: isLtr ? Radius.circular(6) : Radius.zero,
                    )
                : BorderRadius.zero,
            color: isSelected
                ? sideBarConfig.actionsSelectedBackgroundColor
                : sideBarConfig.actionsBackgroundColor,
          ),
          child: AnimatedContainer(
            duration: sideBarConfig.duration,
            height: item.height,
            child: Row(
              children: [
                SizedBox(
                  width: (sideBarConfig.width -
                          (isSelected
                              ? 0
                              : sideBarConfig.selectedActionXOffset) -
                          iconSize) /
                      2,
                ),
                icon,
                SizedBox(
                  width: (sideBarConfig.width -
                          (isSelected
                              ? 0
                              : sideBarConfig.selectedActionXOffset) -
                          iconSize) /
                      2,
                ),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: isExpand ? 1 : 0,
                    duration: Duration(
                      milliseconds: sideBarConfig.duration.inMilliseconds > 100
                          ? sideBarConfig.duration.inMilliseconds - 100
                          : sideBarConfig.duration.inMilliseconds,
                    ),
                    child: text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
