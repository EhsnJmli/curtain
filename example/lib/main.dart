import 'package:curtain/curtain.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(size: 22),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String getText(int page) {
    switch (page) {
      case 0:
        return 'Home Page';
      case 1:
        return 'Map Page';
      case 2:
        return 'Profile Page';
      default:
        return 'Not defined';
    }
  }

  IconData getIcon(int page) {
    switch (page) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.map;
      case 2:
        return Icons.person;
      default:
        return Icons.home;
    }
  }

  String getHeaderText(int page) {
    switch (page) {
      case 0:
        return 'Home Page Header';
      case 1:
        return 'Map Page Header';
      case 2:
        return 'Profile Page Header';
      default:
        return 'Not defined';
    }
  }

  String getShrinkHeaderText(int page) {
    switch (page) {
      case 0:
        return 'Home';
      case 1:
        return 'Map';
      case 2:
        return 'Profile';
      default:
        return 'Not defined';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final headerTextStyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    final actionTextStyle = TextStyle(fontSize: 16);
    return Curtain(
        extendBody: true,
        initialPage: 1,
        curtainSideBarConfig: CurtainSideBarConfig(
          selectedActionXOffset: 10,
          headerBuilder: (isExpand, page) => Container(
            padding: const EdgeInsets.only(top: 32),
            child: isExpand
                ? Text(
                    getHeaderText(page),
                    style: headerTextStyle,
                  )
                : Text(
                    getShrinkHeaderText(page),
                    style: headerTextStyle,
                  ),
          ),
        ),
        scaffoldConfig: ScaffoldConfig(
          drawerEdgeDragWidth: 50,
          persistentWidget: PersistentWidget(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(-2, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text('Persistent Widget'),
            ),
            alignment: Alignment.topRight,
          ),
        ),
        items: List.generate(
          3,
          (page) => CurtainItem(
            page: Container(
              alignment: Alignment.center,
              child: Text(
                getText(page),
                style: pageTextStyle,
              ),
            ),
            action: CurtainAction(
              icon: Icon(getIcon(page)),
              text: Text(
                getText(page),
                style: actionTextStyle,
              ),
            ),
          ),
        ));
  }
}
