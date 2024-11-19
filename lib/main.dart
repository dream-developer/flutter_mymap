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
  @override
  Widget build(BuildContext context) {
    final fm =  FlutterMap( // 1
      options: MapOptions( // onTap使用時では、const は外す
        // 中心座標(経度/緯度は国会議事堂)
        initialCenter: LatLng(35.67604049, 139.74527642),
        initialZoom: 16,
        minZoom: 5,
        maxZoom: 20,
        onTap: (tapPosition, latLng) {
          print(latLng); // LatLng型
          print(latLng.latitude); // 緯度
          print(latLng.longitude); // 経度
        }
      ),
      children: [
        TileLayer( // 5
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // 6
          userAgentPackageName: 'com.example.app', // 7
        ),
        MarkerLayer(
          markers: [         
            Marker(
              width: 20.0,
              height: 20.0,
              point: LatLng(35.67604049, 139.74527642), // ピンの位置
              child: GestureDetector(
                onTap: () {
                  print("マーカーのタップ時の処理");
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              rotate: true, // マーカーまで回転しないようにする場合  
          ),
          ],
        ),
                                                                                                                                
        RichAttributionWidget( // 8
          attributions: [
            // OpenStreetMapのクレジット表記
            TextSourceAttribution( // 9
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