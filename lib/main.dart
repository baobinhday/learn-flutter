import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_app/features/layout_demo/layout_demo.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 650);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Custom window with Flutter";
    win.show();
  });
}

const borderColor = Color(0xFF805306);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Flutter layout demo',
          home: AppLayout(),
        ));
  }
}

class MyAppState extends ChangeNotifier {
  var expanded = true;

  void toggleExpand() {
    print(expanded);
    expanded = !expanded;
    notifyListeners();
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  var selectedMenu = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var expanded = appState.expanded;
    Widget page;
    switch (selectedMenu) {
      case 0:
        page = LayoutDemo();
        break;
      default:
        throw UnimplementedError('no widget for $selectedMenu');
    }
    return LayoutBuilder(builder: (context, constrains) {
      return Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppbar(),
          Expanded(
              child: Row(
            children: [
              SafeArea(
                  child: NavigationRail(
                extended: expanded,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      label: Text("Layout demo")),
                  NavigationRailDestination(
                      icon: Icon(Icons.text_snippet), label: Text("Words")),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text("Favorite words")),
                ],
                trailing: Expanded(
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: TextButton(
                            onPressed: () {
                              appState.toggleExpand();
                            },
                            child: Icon(Icons.menu)))),
                selectedIndex: selectedMenu,
                onDestinationSelected: (value) => {
                  setState(() {
                    selectedMenu = value;
                  })
                },
              )),
              Expanded(
                  child: Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: page)),
            ],
          ))
        ],
      ));
    });
  }
}

const sidebarColor = Color(0xFFF6A00C);

const backgroundStartColor = Color(0xFFFFD500);
const backgroundEndColor = Color(0xFFF6A00C);

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[50],
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: WindowTitleBarBox(
              child: MoveWindow(
                  child: Center(
                child: Text("Test Flutter"),
              )),
            ),
          ),
          MinimizeWindowButton(colors: buttonColors),
          MaximizeWindowButton(colors: buttonColors),
          CloseWindowButton(colors: closeButtonColors),
        ],
      ),
    );
  }
}
