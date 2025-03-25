import 'package:flutter/material.dart';
import 'package:lipalocal/database/database_helper.dart';

class ArtisanListPage extends StatefulWidget {
  const ArtisanListPage({super.key});

  @override
  ArtisanListPageState createState() => ArtisanListPageState();
}

class ArtisanListPageState extends State<ArtisanListPage> {
  late Future<List<Map<String, dynamic>>> _artisanDataFuture;

  @override
  void initState() {
    super.initState();
    _artisanDataFuture = DatabaseHelper.getArtisans(); // Use the specific method for artisans
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artisans'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _artisanDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final artisans = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: artisans.length,
                itemBuilder: (context, index) {
                  final artisan = artisans[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(artisan['imageUrl'] ?? ''),
                        radius: 30,
                      ),
                      title: Text(
                        artisan['fullName'] ?? 'Unknown Artisan',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skill: ${artisan['skill'] ?? 'Unknown Skill'}'),
                          Text('Business: ${artisan['businessName'] ?? 'Unknown Business'}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtisanDetailsPage(artisan: artisan),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('No artisans found.'));
          }
        },
      ),
    );
  }
}

class ArtisanDetailsPage extends StatelessWidget {
  final Map<String, dynamic> artisan;

  const ArtisanDetailsPage({super.key, required this.artisan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${artisan['fullName']} Details'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(artisan['imageUrl'] ?? ''),
              radius: 50,
            ),
            const SizedBox(height: 16),
            Text(
              artisan['fullName'] ?? 'Unknown Artisan',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Skill: ${artisan['skill'] ?? 'Unknown Skill'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Business: ${artisan['businessName'] ?? 'Unknown Business'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Contact: ${artisan['phoneNumber'] ?? 'No phone provided'}',
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