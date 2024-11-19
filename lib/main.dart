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
      CircleLayer(
        circles: [  
          CircleMarker(
            point: const LatLng(35.67604049, 139.74527642),
            // 「メートル単位」を有効
            useRadiusInMeter: true,
            radius: 250, // 半径0.25km(250m)
            color: Colors.blue.withOpacity(0.1),
            borderColor: Colors.blue,
            borderStrokeWidth: 1.0, // 枠線の太さ
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