import 'package:curtain/src/persistent_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'side_bar/side_bar.dart';

const double _kSideBarWidth = 65, _kSideBarExpandWidth = 210;
const Duration _kSideBarDuration = Duration(milliseconds: 250);

class CurtainSideBarConfig {
  /// Config of the [CurtainSideBar].
  const CurtainSideBarConfig({
    this.width = _kSideBarWidth,
    this.expandWidth = _kSideBarExpandWidth,
    this.duration = _kSideBarDuration,
    this.headerBuilder,
    this.backgroundColor = Colors.white,
    this.itemsBackgroundColor = Colors.white,
    this.itemsSelectedBackgroundColor = Colors.green,
    this.itemsSpacing = 15,
    this.selectedItemXOffset = 10,
  })  : assert(width != null, 'width must not be null'),
        assert(expandWidth != null, 'expandWidth must not be null'),
        assert(expandWidth > width, 'expandWidth should be greater than width'),
        assert(duration != null, 'duration must not be null');

  /// Default width of [CurtainSideBar] when its not hovered.
  /// 
  /// defaults to [_kSideBarWidth].
  final double width;
  
  /// Width of [CurtainSideBar] when it's Hovered on screens with width more than 700 
  /// and width on drawer on screens with width lower than 700.
  /// 
  /// defaults to [_kSideBarExpandWidth].
  final double expandWidth;
  
  /// [CurtainSideBar] expand and shrink duration.
  /// 
  /// defaults to [_kSideBarDuration].
  final Duration duration;
  
  /// Builds header for the [CurtainSideBar].
  final Widget Function(bool isExpand, int page) headerBuilder;

  /// [CurtainSideBar] background color.
  ///
  /// defaults to [Colors.white].
  final Color backgroundColor;

  /// [CurtainSideBar] items background color when it is not selected.
  ///
  /// defaults to [Colors.white]
  final Color itemsBackgroundColor;

  /// [CurtainSideBar] items background color when it is selected.
  ///
  /// defaults to [Colors.white]
  final Color itemsSelectedBackgroundColor;

  /// Spacing between the items of the [CurtainSideBar].
  ///
  /// defaults to 15.
  final double itemsSpacing;

  /// Selected Item edge X offset.
  ///
  /// defaults to 10.
  final double selectedItemXOffset;
}

class ScaffoldConfig {
  /// Curtain main page scaffold config.
  ScaffoldConfig({
    this.key,
    this.extendBodyBehindAppBar = false,
    this.mobileAppBar,
    this.persistentWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.drawerScrimColor,
    this.backgroundColor,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
  })  : assert(primary != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null);

  /// Widget which always displayed in all pages.
  final PersistentWidget persistentWidget;

  final Key key;

  /// If true, and an [mobileAppBar] is specified, then the height of the [body] is
  /// extended to include the height of the app bar and the top of the body
  /// is aligned with the top of the app bar.
  ///
  /// This is useful if the app bar's [AppBar.backgroundColor] is not
  /// completely opaque.
  ///
  /// This property is false by default. It must not be null.
  ///
  /// See also:
  ///
  ///  * [extendBody], which extends the height of the body to the bottom
  ///    of the scaffold.
  final bool extendBodyBehindAppBar;

  /// An app bar to display at the top of the scaffold only on tablet and mobile.
  final PreferredSizeWidget mobileAppBar;

  /// A button displayed floating above [body], in the bottom right corner.
  ///
  /// Typically a [FloatingActionButton].
  final Widget floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  ///
  /// If null, the [ScaffoldState] will use the default location, [FloatingActionButtonLocation.endFloat].
  final FloatingActionButtonLocation floatingActionButtonLocation;

  /// Animator to move the [floatingActionButton] to a new [floatingActionButtonLocation].
  ///
  /// If null, the [ScaffoldState] will use the default animator, [FloatingActionButtonAnimator.scaling].
  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  /// A set of buttons that are displayed at the bottom of the scaffold.
  ///
  /// Typically this is a list of [TextButton] widgets. These buttons are
  /// persistently visible, even if the [body] of the scaffold scrolls.
  ///
  /// These widgets will be wrapped in a [ButtonBar].
  ///
  /// The [persistentFooterButtons] are rendered above the
  /// [bottomNavigationBar] but below the [body].
  final List<Widget> persistentFooterButtons;

  /// Optional callback that is called when the [Scaffold.drawer] is opened or closed.
  final DrawerCallback onDrawerChanged;

  /// A panel displayed to the side of the [body], often hidden on mobile
  /// devices. Swipes in from right-to-left ([TextDirection.ltr]) or
  /// left-to-right ([TextDirection.rtl])
  ///
  /// Typically a [Drawer].
  ///
  /// To open the drawer, use the [ScaffoldState.openEndDrawer] function.
  ///
  /// To close the drawer, use [Navigator.pop].
  ///
  /// {@tool dartpad --template=stateful_widget_material_no_null_safety}
  /// To disable the drawer edge swipe, set the
  /// [Scaffold.endDrawerEnableOpenDragGesture] to false. Then, use
  /// [ScaffoldState.openEndDrawer] to open the drawer and [Navigator.pop] to
  /// close it.
  ///
  /// ```dart
  /// final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ///
  /// void _openEndDrawer() {
  ///   _scaffoldKey.currentState.openEndDrawer();
  /// }
  ///
  /// void _closeEndDrawer() {
  ///   Navigator.of(context).pop();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///     key: _scaffoldKey,
  ///     appBar: AppBar(title: Text('Drawer Demo')),
  ///     body: Center(
  ///       child: ElevatedButton(
  ///         onPressed: _openEndDrawer,
  ///         child: Text('Open End Drawer'),
  ///       ),
  ///     ),
  ///     endDrawer: Drawer(
  ///       child: Center(
  ///         child: Column(
  ///           mainAxisAlignment: MainAxisAlignment.center,
  ///           children: <Widget>[
  ///             const Text('This is the Drawer'),
  ///             ElevatedButton(
  ///               onPressed: _closeEndDrawer,
  ///               child: const Text('Close Drawer'),
  ///             ),
  ///           ],
  ///         ),
  ///       ),
  ///     ),
  ///     // Disable opening the end drawer with a swipe gesture.
  ///     endDrawerEnableOpenDragGesture: false,
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final Widget endDrawer;

  /// Optional callback that is called when the [Scaffold.endDrawer] is opened or closed.
  final DrawerCallback onEndDrawerChanged;

  /// The color to use for the scrim that obscures primary content while a drawer is open.
  ///
  /// By default, the color is [Colors.black54]
  final Color drawerScrimColor;

  /// The color of the [Material] widget that underlies the entire Scaffold.
  ///
  /// The theme's [ThemeData.scaffoldBackgroundColor] by default.
  final Color backgroundColor;

  /// The persistent bottom sheet to display.
  ///
  /// A persistent bottom sheet shows information that supplements the primary
  /// content of the app. A persistent bottom sheet remains visible even when
  /// the user interacts with other parts of the app.
  ///
  /// A closely related widget is a modal bottom sheet, which is an alternative
  /// to a menu or a dialog and prevents the user from interacting with the rest
  /// of the app. Modal bottom sheets can be created and displayed with the
  /// [showModalBottomSheet] function.
  ///
  /// Unlike the persistent bottom sheet displayed by [showBottomSheet]
  /// this bottom sheet is not a [LocalHistoryEntry] and cannot be dismissed
  /// with the scaffold appbar's back button.
  ///
  /// If a persistent bottom sheet created with [showBottomSheet] is already
  /// visible, it must be closed before building the Scaffold with a new
  /// [bottomSheet].
  ///
  /// The value of [bottomSheet] can be any widget at all. It's unlikely to
  /// actually be a [BottomSheet], which is used by the implementations of
  /// [showBottomSheet] and [showModalBottomSheet]. Typically it's a widget
  /// that includes [Material].
  ///
  /// See also:
  ///
  ///  * [showBottomSheet], which displays a bottom sheet as a route that can
  ///    be dismissed with the scaffold's back button.
  ///  * [showModalBottomSheet], which displays a modal bottom sheet.
  final Widget bottomSheet;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  /// Whether this scaffold is being displayed at the top of the screen.
  ///
  /// If true then the height of the [mobileAppBar] will be extended by the height
  /// of the screen's status bar, i.e. the top padding for [MediaQuery].
  ///
  /// The default value of this property, like the default value of
  /// [AppBar.primary], is true.
  final bool primary;

  /// {@macro flutter.material.DrawerController.dragStartBehavior}
  final DragStartBehavior drawerDragStartBehavior;

  /// The width of the area within which a horizontal swipe will open the
  /// drawer.
  ///
  /// By default, the value used is 20.0 added to the padding edge of
  /// `MediaQuery.of(context).padding` that corresponds to the surrounding
  /// [TextDirection]. This ensures that the drag area for notched devices is
  /// not obscured. For example, if `TextDirection.of(context)` is set to
  /// [TextDirection.ltr], 20.0 will be added to
  /// `MediaQuery.of(context).padding.left`.
  final double drawerEdgeDragWidth;

  /// Determines if the [Scaffold.drawer] can be opened with a drag
  /// gesture.
  ///
  /// By default, the drag gesture is enabled.
  final bool drawerEnableOpenDragGesture;

  /// Determines if the [Scaffold.endDrawer] can be opened with a
  /// drag gesture.
  ///
  /// By default, the drag gesture is enabled.
  final bool endDrawerEnableOpenDragGesture;
}
