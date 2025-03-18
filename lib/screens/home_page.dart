// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'artisan_list_page.dart';
import 'location_tracker_page.dart';

void main() {
  runApp(const LipaLocalApp() as Widget);
}

class LipaLocalApp extends StatelessWidget {
  const LipaLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/artisans': (context) => const ArtisanListPage(),
        '/location': (context) => const LocationTrackerPage(),
      },
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const ArtisanListPage(),
    const LocationTrackerPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LipaLocal', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange[600]!,
                const Color.fromRGBO(241, 23, 70, 1)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 236, 118, 38),
              ),
              child: Text(
                'LipaLocal',
                style: TextStyle(
                    color: Color.fromARGB(255, 248, 246, 246), fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('My Listings'),
              onTap: () {
                Navigator.pushNamed(context, '/listings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.pushNamed(context, '/categories');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('My Orders'),
              onTap: () {
                Navigator.pushNamed(context, '/orders');
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration),
              title: const Text('Registration'),
              onTap: () {
                Navigator.pushNamed(context, '/registration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {
                Navigator.pushNamed(context, '/messages');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pushNamed(context, '/aboutus');
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/signup');
                Navigator.pushNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: 'Artisans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section
          CarouselSlider(
            items: [
              Image.asset('lib/images/two.jpg', fit: BoxFit.cover),
              Image.asset('lib/images/four.jpg', fit: BoxFit.cover),
            ],
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
          ),

          // Welcome Message
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to LipaLocal!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Get the best artifacts from the best local artisans.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 37, 32, 32),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/listings');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('List a Souvenir'),
                ),
              ],
            ),
          ),

          // Categories Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryItem('Handicrafts', Icons.brush),
                      _buildCategoryItem('Textiles', Icons.texture),
                      _buildCategoryItem('Jewelry', Icons.local_offer),
                      _buildCategoryItem('Woodwork', Icons.timelapse),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Featured Products Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(
                    16,
                    (index) => Card(
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.asset(
                              'lib/images/three.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product $index',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Ksh2000 .00',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade100,
            radius: 30,
            child: Icon(icon, color: Colors.orange.shade600),
          ),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
