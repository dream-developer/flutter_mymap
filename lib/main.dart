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
      PolygonLayer(
        polygons: [ 
          Polygon(
            points: [
              const LatLng(35.678641, 139.745057),
              const LatLng(35.676109, 139.749721),
              const LatLng(35.674842, 139.739192),
            ],
            color: Colors.blue.withOpacity(0.2),
            borderColor: Colors.blue,
            borderStrokeWidth: 2.0, // 枠線の太さ
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