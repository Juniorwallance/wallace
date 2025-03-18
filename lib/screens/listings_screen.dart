import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artisan Listings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListingsScreen(),
    );
  }
}

class ListingsScreen extends StatelessWidget {
  const ListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArtisanListScreen(),
              ),
            );
          },
          child: const Text('View Artisans'),
        ),
      ),
    );
  }
}

class Artisan {
  final String name;
  final String specialty;
  final String location;
  final String description;
  final String imageUrl;

  const Artisan({
    required this.name,
    required this.specialty,
    required this.location,
    required this.description,
    required this.imageUrl,
  });
}

class ArtisanListScreen extends StatelessWidget {
  final List<Artisan> artisans = const [
    Artisan(
      name: 'John Doe',
      specialty: 'Woodwork',
      location: 'Thika',
      description: 'Expert in creating wooden furniture and sculptures.',
      imageUrl: 'assets/placeholder2.png',
    ),
    Artisan(
      name: 'Jane Smith',
      specialty: 'Pottery',
      location: 'Nairobi',
      description: 'Creates beautiful pottery and ceramic items.',
      imageUrl: 'assets/placeholder1.png',
    ),
    Artisan(
      name: 'Peter Parker',
      specialty: 'Metalcraft',
      location: 'Kiambu',
      description: 'Specializes in metal works and artistic designs.',
      imageUrl: 'assets/placeholder.png',
    ),
  ];

  const ArtisanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(
        'Artisan list length: ${artisans.length}'); // Debugging print statement
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lipa Local Artisans'),
      ),
      body: ListView.separated(
        itemCount: artisans.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          // ignore: avoid_print
          print(
              'Building tile for ${artisans[index].name}'); // Debugging print statement
          return _buildArtisanTile(context, artisans[index]);
        },
      ),
    );
  }

  Widget _buildArtisanTile(BuildContext context, Artisan artisan) {
    return ListTile(
      leading: FadeInImage.assetNetwork(
        placeholder: 'assets/placeholder.png', // Ensure this path is correct
        image: artisan.imageUrl,
        fit: BoxFit.cover,
        imageErrorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error); // Error handling for image
        },
      ),
      title: Text(artisan.name),
      subtitle: Text('${artisan.specialty} - ${artisan.location}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtisanDetailScreen(artisan: artisan),
          ),
        );
      },
    );
  }
}

class ArtisanDetailScreen extends StatelessWidget {
  final Artisan artisan;

  const ArtisanDetailScreen({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artisan.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              placeholder:
                  'assets/placeholder.png', // Ensure this path is correct
              image: artisan.imageUrl,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error); // Error handling for image
              },
            ),
            const SizedBox(height: 16),
            Text(
              artisan.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${artisan.specialty} - ${artisan.location}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            Text(
              artisan.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
