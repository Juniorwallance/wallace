import 'package:flutter/material.dart';

class ArtisanListPage extends StatelessWidget {
  const ArtisanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisans'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: artisans.length, // Replace with actual data source
          itemBuilder: (context, index) {
            final artisan = artisans[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(artisan['image'] ?? ''),
                  radius: 30,
                ),
                title: Text(
                  artisan['name'] ?? 'Unknown Artisan',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ${artisan['location'] ?? 'Unknown Location'}',
                    ),
                    Text('Shop Name: ${artisan['shopName'] ?? 'Unknown Shop'}'),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ArtisanDetailsPage(artisan: artisan),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Sample Data for Artisans (Replace with actual data source)
final List<Map<String, dynamic>> artisans = [
  {
    'name': 'John Kimani',
    'location': 'Nairobi, Kenya',
    'shopName': 'John Crafts',
    'image': 'https://via.placeholder.com/150?text=Artisan+1',
  },
  {
    'name': 'Jane Musyo',
    'location': 'Mombasa, Kenya',
    'shopName': 'Smith Art',
    'image': 'https://via.placeholder.com/150?text=Artisan+2',
  },
  {
    'name': 'Michael Odhiambo',
    'location': 'Kisumu, Kenya',
    'shopName': 'Johnson Creations',
    'image': 'https://via.placeholder.com/150?text=Artisan+3',
  },
];

// Artisan Details Page
class ArtisanDetailsPage extends StatelessWidget {
  final Map<String, dynamic> artisan;

  const ArtisanDetailsPage({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${artisan['name']} Details'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(artisan['image'] ?? ''),
              radius: 50,
            ),
            const SizedBox(height: 16),
            Text(
              artisan['name'] ?? 'Unknown Artisan',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${artisan['location'] ?? 'Unknown Location'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Shop Name: ${artisan['shopName'] ?? 'Unknown Shop'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement contact logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Contact Artisan'),
            ),
          ],
        ),
      ),
    );
  }
}
