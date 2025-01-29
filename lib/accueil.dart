import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'formulaireC.dart';

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


class ProductBox extends StatelessWidget {
  final String title;
  final String imageUrl;

  const ProductBox(this.title, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl), // Charger l'image à partir de l'URL
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _AccueilPageState extends State<AccueilPage> {
  int _selectedIndex = 0;
  bool _isAddMenuVisible = false;
  List<String> podiumImages = ['', '', ''];

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
  void initState() {
    super.initState();
    _fetchPodiumImages();
  }

  Future<void> _fetchPodiumImages() async {
    for (int i = 1; i <= 3; i++) {
      final response = await http.get(Uri.parse('http://localhost:3000/product//$i'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          podiumImages[i - 1] = data.isNotEmpty ? data[0]['image_url'] : ''; // Met à jour l'image
        });
      } else {
        print('Erreur lors de la récupération des images pour le podium $i');
      }
    }
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
            iconSize: 25,
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0),
              child: const Icon(
                Icons.segment,
                color: Color.fromARGB(255, 85, 31, 142),
                ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 20.0),
            iconSize: 22,
            icon: const Icon(Icons.notifications_active),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: true, 
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color:  Color.fromARGB(255, 85, 31, 142),
                  ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor:  const Color.fromARGB(255, 241, 241, 241),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 20),
                  ListTile( 
                    leading: const Icon(Icons.home, size: 22.0),
                    title: const Text('Accueil'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.person, size: 22.0),
                    title: const Text('Profile'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag, size: 22.0),
                    title: const Text('Gestion des Produits'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.inventory, size: 22.0),
                    title: const Text('Gestion des Stocks'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.receipt_long, size: 22.0),
                    title: const Text('Gestion des Commandes'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.engineering, size: 22.0),
                    title: const Text('Gestion des Utilisateur'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.notifications, size: 22.0),
                    title: const Text('Notification'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.query_stats, size: 22.0),
                    title: const Text('Statistique'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.settings, size: 22.0),
                    title: const Text('Paramètres'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 2),
                  ListTile(
                    leading: const Icon(Icons.support_agent, size: 22.0),
                    title: const Text('Support'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Bouton de déconnexion en bas
            Container(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 85, 31, 142),
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FormulaireC(title: "Connexion",)),
                  );
                },

                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),

                    SizedBox(width: 8),
                    Text(
                      'Se Déconnecter',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      body: Stack(
        children: [

          // Partie Produit carré podium
          Positioned(
            top: 20,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              width: 500,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 223, 222, 222),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Produit 1 - Le plus bas
                  Transform.translate(
                    offset: const Offset(0, 0), // Décale légèrement vers le bas
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars, color: Colors.grey, size: 40), // Icône pour 2ème
                        SizedBox(height: 10),
                        ProductBox("Produit 2"),
                      ],
                    ),
                  ),
                  // Produit 2 - Celui du milieu
                  Transform.translate(
                    offset: const Offset(0, -15), // Décale légèrement vers le bas
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars, color: Colors.amber, size: 40), // Icône pour 1er
                        SizedBox(height: 10),
                        ProductBox("Produit 1"),
                      ],
                    ),
                  ),
                  // Produit 3 - Le plus haut
                  Transform.translate(
                    offset: const Offset(0, 10), // Décale légèrement vers le bas
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stars, color: Colors.red, size: 40), // Icône pour 3ème
                        SizedBox(height: 10),
                        ProductBox("Produit 3"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),



          // Partie Raccourcie bouton gerer
          if (_isAddMenuVisible)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
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
                    'Raccourci',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action pour ajouter
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 245, 196, 62),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(30, 30),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Ajouter',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action pour ajouter
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 240, 134, 76),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(30, 30),
                            ),
                            child: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Supprimer',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action pour supprimer
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 239, 6, 128),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: const Size(0, 0), // Taille carrée
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Supprimer',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      )

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Partie Bar nav en bas 
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavBarItem(Icons.home, "Accueil", 0),
          _buildNavBarItem(Icons.shopping_bag, "produits", 1),
          _buildAddItem(),
          _buildNavBarItem(Icons.signal_cellular_alt, "Progres", 3),
          _buildNavBarItem(Icons.account_circle, "Profile", 4),
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

  // Partie Bar nav en bas carré violet
  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? const Color.fromARGB(255, 85, 31, 142)
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

  // Partie Bar nav en bas bouton Gérer 
  BottomNavigationBarItem _buildAddItem() {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 2, 126),
          borderRadius: BorderRadius.circular(_isAddMenuVisible ? 10 : 20),
        ),
        padding: EdgeInsets.all(_isAddMenuVisible ? 10.0 : 4.0),
        child: Icon(
          _isAddMenuVisible ? Icons.close : Icons.add,
          color: Colors.white,
        ),
      ),
      label: 'Gérer',
      tooltip: 'Gérer',
    );
  }


}
