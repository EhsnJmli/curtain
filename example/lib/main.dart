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
  CurtainPageController curtainPageController =
      CurtainPageController(initialPage: 1);

  String getText(int page) {
    switch (page) {
      case 0:
        return 'Home Page';
      case 1:
        return 'Map Page';
      case 2:
        return 'Profile Page';
      case 3:
        return 'Exit';
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
      case 3:
        return Icons.logout;
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

  String getFooterText(int page) {
    switch (page) {
      case 0:
        return 'Home Page Footer';
      case 1:
        return 'Map Page Footer';
      case 2:
        return 'Profile Page Footer';
      default:
        return 'Not defined';
    }
  }

  String getShrinkFooterText(int page) {
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
  void initState() {
    curtainPageController.addListener(() {
      print(curtainPageController.previousPage);
      print(curtainPageController.page);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final headerTextStyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    final actionTextStyle = TextStyle(fontSize: 16);
    return Curtain(
      extendBody: true,
      controller: curtainPageController,
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
        footerBuilder: (isExpand, page) => Container(
          padding: const EdgeInsets.only(bottom: 32),
          child: isExpand
              ? Text(
                  getFooterText(page),
                  style: headerTextStyle,
                )
              : Text(
                  getShrinkFooterText(page),
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
        4,
        (page) => CurtainItem(
          page: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getText(page),
                  style: pageTextStyle,
                ),
                if (page == 0) ...[
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      curtainPageController.goToPage(2);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.all(16),
                    ),
                    child: Text(
                      'Go To Profile Page',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ]
              ],
            ),
          ),
          action: CurtainAction(
              icon: Icon(getIcon(page)),
              text: Text(
                getText(page),
                style: actionTextStyle,
              ),
              onTap: page == 3
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              child: Text(
                                'Are you really want to exit?',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: [
                                  TextButton(
                                    child: Text('YES'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            )
                          ],
                          title: Text(
                            'Exit',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                    }
                  : null),
        ),
      ),
    );
  }
}
