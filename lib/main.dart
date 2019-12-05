import 'package:bloc/bloc.dart';
import 'package:chat_app_client/api/AuthService.dart';
import 'package:chat_app_client/blocs/bloc.dart';
import 'package:chat_app_client/simple_bloc_delegate.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_client/router.dart' as router;

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  AuthService authService = new AuthService();
  var app = MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        builder: (context) =>
            AuthenticationBloc()..add(CheckCurrentAuthState()),
      ),
      BlocProvider<SignupBloc>(
        builder: (context) => SignupBloc(authService),
      ),
      BlocProvider<UsersListBloc>(
        builder: (context) => UsersListBloc(),
      ),
      BlocProvider<ConversationBloc>(
        builder: (context) => ConversationBloc(),
      ),
    ],
    child: MyApp(),
  );
  return runApp(app);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(elevation: 0.1),
      ),
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: router.RouteConstants.DecisionPage,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var flush;

  @override
  void initState() {
    flush = Flushbar(
      borderRadius: 8,
      title: "Hey Ninja",
      message:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.elasticIn,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
            color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)
      ],
      backgroundGradient:
          LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: true,
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),
      mainButton: FlatButton(
        onPressed: () {
          dismissFlush();
        },
        child: Text(
          "CLAP",
          style: TextStyle(color: Colors.amber),
        ),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        "Hello Hero",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.yellow[600],
            fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        "You killed that giant monster in the city. Congratulations!",
        style: TextStyle(
            fontSize: 18.0,
            color: Colors.green,
            fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..onStatusChanged = (FlushbarStatus status) {
        switch (status) {
          case FlushbarStatus.SHOWING:
            {
              print('showing');
              break;
            }
          case FlushbarStatus.IS_APPEARING:
            {
              print('appearing');
              break;
            }
          case FlushbarStatus.IS_HIDING:
            {
              print('hidding');
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              print('dismissed');
              break;
            }
        }
      };
    super.initState();
  }

  void dismissFlush() {
    flush.dismiss();
  }

  void _incrementCounter() {
    flush.show(context);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
