import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DeepLinkBloc _deepLinkBloc;

  @override
  void initState() {
    _deepLinkBloc = DeepLinkBloc();
    initUniLinks(_deepLinkBloc);
    _deepLinkBloc.getUri.listen((uri) => print('uri $uri'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Deep Link Test',
            ),
            StreamBuilder(
              stream: _deepLinkBloc.getUri,
              builder: (context, snapshot) => Text('Url deepLink: ${snapshot.data}'),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> initUniLinks(DeepLinkBloc deepLinkBloc) async {
  Uri initialLink = await getInitialUri();

  if (initialLink != null) {
    deepLinkBloc.setUri.add(initialLink);
    print(initialLink);
  }

  getUriLinksStream().listen((Uri link) {
    print(link);
    deepLinkBloc.setUri.add(initialLink);
  }, onError: (err) {
    print('error $err');
  });
}

class DeepLinkBloc {
  DeepLinkBloc() {
    setUri.add(Uri());
  }
  final _uri = StreamController<Uri>.broadcast();
  Stream<Uri> get getUri => _uri.stream;
  Sink<Uri> get setUri => _uri.sink;

  void dispose() {
    _uri.close();
  }
}
