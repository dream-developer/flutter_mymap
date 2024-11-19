import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget { 
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> { 
  double _lat = 0.0;
  double _lng = 0.0;

  Future<void> _setLocation() async {  // 1
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled(); // 2
    if (!serviceEnabled) {
      print('位置情報サービスが有効になっていません(ダイアログ表示など)');
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission(); // 3
    permission = await Geolocator.checkPermission();// 4
    if (permission == LocationPermission.denied) { // 5
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('位置情報の許可が拒否されました(ダイアログ表示など)');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        print('位置情報の許可が恒久的に拒否されるよう設定されてます(ダイアログ表示など)');
        return;
      }
    }
  
    Position position = await Geolocator.getCurrentPosition();// 6
    _lat = position.latitude; // 7
    _lng = position.longitude;
    print('現在地の緯度：$_lat');
    print('現在地の経度：$_lng');
 }

  @override
  Widget build(BuildContext context) {

    const body = Text("ボタン押下で現在地をコンソールにデバッグ出力");  

    final fab = Row( // 地図表示の場合、クレジット表記部分が隠れないよう真ん中に配置
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          tooltip: '現在地の取得',
          child: const Icon(Icons.location_on),
          onPressed: () async {
            await _setLocation();
          },
        ),        
      ]
    );

    final sc = Scaffold(
      body: body, // ボディー  
      floatingActionButton: fab,        
    );
    return SafeArea( child: sc, );
  }
}