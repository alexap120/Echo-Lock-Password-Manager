import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:password_manager/screens/login_items/add_card.dart';
import 'package:password_manager/screens/login_items/add_note.dart';
import 'package:password_manager/screens/profile/profile_page.dart';

import '../../models/login_item.dart'; // Your Hive model
import '../../widgets/custom_bottom_nav_bar.dart';
import '../login_items/add_login.dart';
import '../login_items/login_item_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedChip = 'All';
  File? _profileImage;

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final loginBox = Hive.box<LoginItem>('loginBox');

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF328E6E),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.inventory_2_outlined, color: Colors.deepPurple),
        ),
        title: const Text(
          'ConceptX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => ProfilePopup(),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: -150,
            left: -100,
            right: -100,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(300, 100),
                ),
                color: Color(0xFF328E6E),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search any items',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildChip('All'),
                          const SizedBox(width: 8),
                          _buildChip('Login'),
                          const SizedBox(width: 8),
                          _buildChip('Secure Note'),
                          const SizedBox(width: 8),
                          _buildChip('Card'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Box<LoginItem>>(
                  valueListenable: loginBox.listenable(),
                  builder: (context, box, _) {
                    final allItems = box.values.toList();

                    final filteredItems = allItems.where((item) {
                      final matchesSearch = item.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                          item.username
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());

                      final matchesChip = _selectedChip == 'All' ||
                          item.type.toLowerCase() == _selectedChip.toLowerCase();

                      return matchesSearch && matchesChip;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/no_items.png',
                                width: 150,
                                height: 150,
                                color: const Color(0xFF328E6E),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'There are currently no items\nStart adding some!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => LoginDetailsBottomSheet(
                                  loginItem: item,
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF90C67C),
                              ),
                            ),
                            subtitle: Text(
                              item.username,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.more_horiz, size: 28),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onTabTapped,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color(0xFF328E6E),
        foregroundColor: Colors.white,
        spacing: 8,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.key),
            backgroundColor: const Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Login',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddLoginPopup()),
              );
              setState(() {});
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.note_add_outlined),
            backgroundColor: const Color(0xFF67AE6E),
            foregroundColor: Colors.white,
            label: 'Add Note',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNotePopup()),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add_card_outlined),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF67AE6E),
            label: 'Add Card',
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                builder: (context) => const AddCardPopup(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final bool selected = _selectedChip == label;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.grey),
      ),
      selected: selected,
      onSelected: (_) {
        setState(() => _selectedChip = label);
      },
      selectedColor: const Color(0xFF328E6E),
      backgroundColor: Colors.grey[100],
      shape: const StadiumBorder(),
    );
  }
}
