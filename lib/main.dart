import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart' as gc;

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
  // マップ用コントローラー
  final _mp = MapController();
  // マーカー用のList
  List<Marker> _markers = [];

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
    final fm =  FlutterMap(
      mapController: _mp,  // マップ用コントローラー
      options: const MapOptions( 
        initialCenter: LatLng(35.67604049, 139.74527642),
        initialZoom: 16,
        minZoom: 5,
        maxZoom: 20,
      ),
      children: [
        TileLayer( // タイル
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app', // アプリのパッケージ名を書く
        ),
        MarkerLayer(
          markers: _markers, // 先ほどのマーカー用のListを渡す
        ),
        RichAttributionWidget(
          attributions: [
            // OpenStreetMapのクレジット表記
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
            // その他、必要に応じて表記やリンク等を追加していく事。
          ],
        ),
      ],
    );

    final body = fm;  

    final fab = Row( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          tooltip: '現在地の取得',
          child: const Icon(Icons.location_on),
          onPressed: () async { // awaitするので asyncを付ける
            await _setLocation(); // 【１】ここでawaitしないと_mp.moveが先に行われてしまう。

            final marker = Marker( // 【２】マーカーの作成
              width: 20.0,
              height: 20.0,
              point: LatLng(_lat, _lng), 
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
            );
            _mp.move( // 【３】マップコントローラーで移動
              LatLng(_lat, _lng),
              16.0 // ズーム値も必須
            );             
            _markers.clear(); // 【４】一旦クリア
            _markers.add(marker); // 【５】マーカー用リストに追加
          },
        ),        
      ]
    );

    final sc = Scaffold(
      body: body, // ボディー  
      floatingActionButton: fab,        
    );

    return SafeArea(
      child: sc,
    );
  }
}