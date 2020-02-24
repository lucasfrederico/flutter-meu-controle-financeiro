import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:meu_controle_financeiro/models/nav-tab-item.dart';
import 'package:meu_controle_financeiro/pages/home-page.dart';
import 'package:meu_controle_financeiro/pages/salary-page.dart';

import 'pages/debts-page.dart';

void main() {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Controle Financeiro",
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/salary': (context) => SalaryPage(),
        '/debts': (context) => DebtsPage(),
      },
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedPos = 1;

  double bottomNavBarHeight = 60;

  List<NavTabItem> navTabItems = List.of([
    NavTabItem(
      SalaryPage(),
      TabItem(
        Icons.monetization_on,
        "Salário",
        Colors.greenAccent,
      ),
    ),
    NavTabItem(
      SalaryPage(),
      TabItem(
        Icons.home,
        "Início",
        Colors.blue,
      ),
    ),
    NavTabItem(
      SalaryPage(),
      TabItem(
        Icons.call_received,
        "Dívidas",
        Colors.redAccent,
      ),
    ),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = new CircularBottomNavigationController(selectedPos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Controle Financeiro",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              child: _bodyContainer(),
              padding: EdgeInsets.only(
                  left: 20.0, top: 20.0, right: 20.0, bottom: 100.0),
            ),
            Align(alignment: Alignment.bottomCenter, child: _bottomNav())
          ],
        ),
      ),
    );
  }

  Widget _bodyContainer() {
    Widget body;

    switch (_navigationController.value) {
      case 0:
        body = SalaryPage();
        break;
      case 1:
        body = HomePage();
        break;
      case 2:
        body = DebtsPage();
        break;
    }

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.greenAccent,
        child: body,
      ),
      onTap: () {
        if (_navigationController.value == navTabItems.length - 1) {
          _navigationController.value = 0;
        } else {
          _navigationController.value++;
        }
      },
    );
  }

  Widget _bottomNav() {
    return CircularBottomNavigation(
      List.of(navTabItems.map((item) => item.tabItem)),
      controller: _navigationController,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
        });
      },
    );
  }
}
