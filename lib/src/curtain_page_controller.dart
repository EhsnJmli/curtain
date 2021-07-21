import 'package:curtain/curtain.dart';
import 'package:flutter/cupertino.dart';

class CurtainPageController extends ChangeNotifier {
  CurtainPageController({
    int initialPage = 0,
  })  : _initialPage = initialPage,
        _page = initialPage;

  int _page;
  int? _previousPage;
  final int _initialPage;

  /// The page to show when first creating the [Curtain].
  ///
  /// defaults to 0.
  int get initialPage => _initialPage;

  /// The current page displayed in the controlled [Curtain].
  int get page => _page;

  /// The previous page of the controlled [Curtain].
  int? get previousPage => _previousPage;

  /// Changes which page is displayed in the controlled [Curtain].
  void goToPage(int newPage) {
    _previousPage = _page;
    _page = newPage;
    notifyListeners();
  }
}
