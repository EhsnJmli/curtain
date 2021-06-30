import 'package:flutter/cupertino.dart';

class CurtainPageController extends ChangeNotifier {
  int _page = 0;

  int get page => _page;

  void goToPage(int newPage) {
    _page = newPage;
    notifyListeners();
  }
}
