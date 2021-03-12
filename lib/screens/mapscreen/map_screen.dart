import 'package:countries_app/models/country/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapScreen extends StatefulWidget {
  final Country country;

  const MapScreen({Key key, this.country}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    Country country = widget.country;

    return Scaffold(
      appBar: AppBar(
        title: Text("Map of ${country.name}", overflow: TextOverflow.ellipsis),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(country.latlng.first, country.latlng[1]),
          zoom: 5.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 50.0,
                height: 50.0,
                point: LatLng(country.latlng.first, country.latlng[1]),
                builder: (ctx) => Container(
                  child: Image.asset(
                    "assets/images/marker.png",
                    height: 5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
