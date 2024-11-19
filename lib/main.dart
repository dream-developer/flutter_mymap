import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  final fm =  FlutterMap( // 1
    options: const MapOptions( // 2
      initialCenter: LatLng(35.67604049, 139.74527642), // 3
      initialZoom: 16, // 4
      minZoom: 5,
      maxZoom: 20,
    ),
    children: [
      TileLayer( // 5
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // 6
        userAgentPackageName: 'com.example.app', // 7
      ),
      const MarkerLayer(
        markers: [         
          Marker(
            width: 20.0,
            height: 20.0,
            point: LatLng(35.67604049, 139.74527642), // ピンの位置
            child: Icon( // アイコンを使う例
              Icons.location_on,
              color: Colors.red, // ピンの色
              size: 30, // ピンのサイズ
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
  final app = MaterialApp(home: sc);
  runApp(app);
}