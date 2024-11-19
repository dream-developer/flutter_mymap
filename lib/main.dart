import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
 // マーカー用のList
  final List<Marker> _markers = [];
  // Listに追加する関数
  void _addMarker(LatLng latlng) { // LatLngを受け取る
    final marker = Marker(
      width: 20.0,
      height: 20.0,
      point: latlng, // LatLngをセット
      child: GestureDetector(
        onTap: () { // LatLngより緯度/経度 を取得し出力
          print("${latlng.latitude}：${latlng.longitude}");
        },
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 30,
        ),
      ),
      rotate: true, // マーカーまで回転しないようにする場合  
    );

    setState(() { // Listに追加するタイミングで再描画
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final fm =  FlutterMap(
      options: MapOptions( // onTap使用時では、const は外す
        // 中心座標(経度/緯度は国会議事堂)
        initialCenter: LatLng(35.67604049, 139.74527642),
        initialZoom: 16,
        minZoom: 5,
        maxZoom: 20,
        onTap: (tapPosition, latLng) {
          _addMarker(latLng); // タップした位置にマーカーを追加
        }
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

    final sc = Scaffold(
      body: body, // ボディー        
    );

    return SafeArea(
      child: sc,
    );
  }
}