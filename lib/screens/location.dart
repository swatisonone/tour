import 'package:flutter/material.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class Location {
  final String name;
  final String address;
  final String distance;

  Location({
    required this.name,
    required this.address,
    required this.distance,
  });
}

class LocationsListScreen extends StatelessWidget {
  final List<Location> locations = [
    Location(
      name: 'Taljai Hills',
      address: 'Taljai Forest Area, Pune, Maharashtra',
      distance: 'Tranquil, tree-covered area with jogging paths, a pond & wildlife such as ducks & peacocks.\n3 km',
    ),
    Location(
      name: 'Saras Garden',
      address: 'Swami Vivekanand Road, Suvarnayug Bank, Bibwewadi, Pune, Maharashtra 411037',
      distance: '7.6 km',
    ),
    Location(
      name: 'pataleshwar cave temples',
      address: 'Jangali Maharaj Rd, Revenue Colony, Pune, Maharashtra 411005',
      distance: '6.8 km',
    ),
    Location(
      name: 'Shaniwar Wada',
      address: 'Shaniwar Peth, Pune, Maharashtra 411030',
      distance: 'Peshwa palace fort built in the 1740s, with a main gate big enough to let elephants pass through.\n3.4 km',
    ),
    Location(
      name: 'Saras Baug',
      address: '2170, Sadashiv Peth, Pune, Maharashtra 411030',
      distance: '4.8 km',
    ),
    Location(
      name: 'Pune-Okayama Friendship Garden',
      address: 'Sinhagad Road, Pune, Maharashtra 411030',
      distance: '6.8 km',
    ),
    Location(
      name: 'Aga Khan Palace',
      address: 'Samadhi Road, Pune, Maharashtra 411006',
      distance: '2.8 km',
    ),
    Location(
      name: 'Vetal Hill',
      address: 'Panchawati, Pashan, Pune, Maharashtra 411038',
      distance: '7.6 km',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations List'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: ListTile(
              title: Text(location.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.address),
                  SizedBox(height: 5.0),
                  Text(location.distance, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onTap: () {
                launchGoogleMaps(location.address);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> launchGoogleMaps(String address) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(address)}';
    try {
      await LaunchApp.openApp(
        androidPackageName: 'com.google.android.apps.maps',
        iosUrlScheme: 'comgooglemaps://',
        appStoreLink: 'https://apps.apple.com/us/app/google-maps/id585027354',
        openStore: false,
      );
    } catch (e) {
      print('Error launching Google Maps: $e');
    }
  }
}

