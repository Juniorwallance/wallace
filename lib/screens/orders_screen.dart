import 'package:flutter/material.dart';

/// Global list to hold orders
List<Order> ordersList = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LipaLocal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ArtisanListScreen(),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: const Center(
        child: Text('Orders will be displayed here.'), // Placeholder
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

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class Order {
  final String id;
  final Artisan artisan;
  final Product product;
  final int quantity;
  final DateTime orderTime;

  const Order({
    required this.id,
    required this.artisan,
    required this.product,
    required this.quantity,
    required this.orderTime,
  });
}

/// Displays a list of artisans with an "Order" button.
/// Also has an icon in the AppBar to navigate to the OrdersScreen.
class ArtisanListScreen extends StatelessWidget {
  const ArtisanListScreen({super.key});

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
      imageUrl: 'assets/placeholder.png',
    ),
    Artisan(
      name: 'Peter Parker',
      specialty: 'Metalcraft',
      location: 'Kiambu',
      description: 'Specializes in metal works and artistic designs.',
      imageUrl: 'assets/placeholder1.png',
    ),
  ];

  final Product dummyProduct = const Product(
    id: 'p001',
    name: 'Handmade Featured Item',
    price: 1500.00,
    imageUrl: 'assets/placeholder2.png',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LipaLocal Artisans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: artisans.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final artisan = artisans[index];
          return ListTile(
            leading: FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.png',
              image: artisan.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/default_image.png', fit: BoxFit.cover),
            ),
            title: Text(artisan.name),
            subtitle: Text('${artisan.specialty} - ${artisan.location}'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreen(
                      artisan: artisan,
                      product: dummyProduct,
                    ),
                  ),
                );
              },
              child: const Text('Order'),
            ),
          );
        },
      ),
    );
  }
}

/// OrderScreen allows the tourist (user) to place an order,
/// then adds the order to the global list and shows an order confirmation.
class OrderScreen extends StatefulWidget {
  final Artisan artisan;
  final Product product;

  const OrderScreen({
    super.key,
    required this.artisan,
    required this.product,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int quantity = 1;

  void updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * quantity;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order from ${widget.artisan.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.artisan.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.artisan.specialty),
            const SizedBox(height: 16),
            FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.png',
              image: widget.product.imageUrl,
              height: 150,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 100),
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text('Price: KES ${widget.product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: quantity > 1 ? () => updateQuantity(-1) : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  quantity.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => updateQuantity(1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total: KES ${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Create an order and add it to the global orders list.
                Order newOrder = Order(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  artisan: widget.artisan,
                  product: widget.product,
                  quantity: quantity,
                  orderTime: DateTime.now(),
                );
                ordersList.add(newOrder);

                // Show confirmation dialog. After confirming, navigate to OrdersScreen.
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Order Confirmed'),
                    content: Text(
                      'Your order for $quantity x ${widget.product.name} '
                      'from ${widget.artisan.name} has been placed.\n'
                      'Total: KES ${totalPrice.toStringAsFixed(2)}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog.
                          Navigator.pop(context); // Close the OrderScreen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OrdersScreen(),
                            ),
                          );
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}

/// OrdersScreen now reads from the global ordersList and displays each order

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Your Orders'),
    ),
    body: ordersList.isEmpty
        ? const Center(child: Text('No orders placed yet.'))
        : ListView.builder(
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              final order = ordersList[index];
              return ListTile(
                title: Text('${order.product.name} x${order.quantity}'),
                subtitle: Text(
                    'From ${order.artisan.name} - Total: KES ${(order.product.price * order.quantity).toStringAsFixed(2)}'),
                trailing: Text(
                    '${order.orderTime.hour}:${order.orderTime.minute.toString().padLeft(2, '0')}'),
              );
            },
          ),
  );
}
