import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App admin V1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AccueilPage(title: 'Accueil'),
    );
  }
}

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key, required this.title});

  final String title;

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;
  bool _isAddMenuVisible = false;

  void _onItemTapped(int index) {
    if (index == 2) {
      _toggleAddMenu();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _toggleAddMenu() {
    setState(() {
      _isAddMenuVisible = !_isAddMenuVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.only(left: 10.0),
            iconSize: 30,
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0),
              child: const Icon(Icons.segment),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            iconSize: 30,
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 66, 139, 182),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                // Action pour Accueil
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                // Action pour Paramètres
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('À propos'),
              onTap: () {
                // Action pour À propos
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      body: Stack(
        children: [
          const Center(
            child: Text("xx"),
          ),
          if (_isAddMenuVisible)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ajouter/Supprimer',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Action pour ajouter
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 50),
                        ),
                        child: const Icon(
                          Icons.add_box,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8), // Espacement entre le bouton et le texte
                      const Text(
                        'Ajouter',
                        style: TextStyle(
                          color: Colors.black, // Couleur du texte
                          fontSize: 14, // Taille du texte
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action pour ajouter
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(50, 50), 
                        ),
                        child: const Text('Ajouter', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action pour supprimer
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Bords arrondis
                          ),
                          minimumSize: const Size(50, 50), // Dimensions du bouton
                        ),
                        child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavBarItem(Icons.home, "Accueil", 0),
          _buildNavBarItem(Icons.shopping_bag, "produits", 1),
          _buildAddItem(),
          _buildNavBarItem(Icons.notifications, "Notification", 3),
          _buildNavBarItem(Icons.signal_cellular_alt, "Progres", 4),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        selectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 46, 46, 46)),
        selectedItemColor: const Color.fromARGB(255, 46, 46, 46),
        unselectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 46, 46, 46)),
        unselectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 46, 46, 46)),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? const Color.fromARGB(255, 66, 139, 182)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: _selectedIndex == index
              ? Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 2.0,
                )
              : null,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: _selectedIndex == index ? Colors.white : Colors.grey,
        ),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildAddItem() {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 66, 139, 182),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          _isAddMenuVisible ? Icons.close : Icons.add,
          color: Colors.white,
        ),
      ),
      label: 'Gérer',
    );
  }
}
