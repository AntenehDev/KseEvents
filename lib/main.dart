import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:KseEvents/pages/loginScreen.dart';
import 'package:KseEvents/pages/wishlist.dart';
import 'package:KseEvents/pages/Event.dart';
import 'package:KseEvents/pages/Shows.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        accentColor: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ListPage();
      case 1:
        return ShowsPage();
      case 2:
        return FutureBuilder<FirebaseUser>(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              FirebaseUser user = snapshot.data;
              return WishlistPage(uid: user.uid);
            } else {
              return LoginScreen();
            }
          },
        );
        break;
      default:
        return ListPage();
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Kse',
      theme: ThemeData(
        primaryColor: Colors.black,
        secondaryHeaderColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("K"),
              Text(
                "SE",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: callPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            _currentIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              title: Text('Events'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv),
              title: Text('Shows'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ac_unit),
              title: Text('Wishlist'),
            ),
          ],
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/app': (BuildContext context) => new LoginScreen()
      },
    );
  }
}
