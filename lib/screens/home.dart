import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> items = [
    {'title': 'Login A', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login B', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login C', 'email': 'someEmail@gmail.com', 'shared': true},
    {'title': 'Login D', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login E', 'email': 'someEmail@gmail.com', 'shared': false},
    {'title': 'Login F', 'email': 'someEmail@gmail.com', 'shared': true},
    {'title': 'Login G', 'email': 'someEmail@gmail.com', 'shared': false},
  ];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.inventory_2_outlined, color: Colors.deepPurple),
        ),
        title: const Text(
          'ConceptX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
            //  backgroundImage: AssetImage('assets/profile.jpg'), // replace with your own image path
              radius: 18,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['email']),
                  if (item['shared']) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text("Shared by", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 6),
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage('assets/user1.jpg'), // sample shared user
                        ),
                        SizedBox(width: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage('assets/user2.jpg'), // another user
                        ),
                      ],
                    ),
                  ]
                ],
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
