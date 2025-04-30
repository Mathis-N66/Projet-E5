import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
      theme: ThemeData(useMaterial3: true),
      home: const AccueilPage(title: 'Accueil'),
    );
  }
}

class Produit {
  final int id;
  final String nom;
  final String imageUrl;

  Produit({required this.id, required this.nom, required this.imageUrl});

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'],
      nom: json['nom'],
      imageUrl: json['image_url'],
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
  List<String> imageUrls = ["", "", ""];
  List<Produit> produits = [];

  Future<void> RecupImg() async {
    for (int i = 1; i <= 3; i++) {
      final url = Uri.parse('http://10.0.2.2:3000/product/$i');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            imageUrls[i - 1] = data[0]["image_url"];
          });
        }
      }
    }
  }

Future<void> fetchProduits() async {
  final url = Uri.parse('http://10.0.2.2:3000/products');
  try {
    final response = await http.get(url);
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        produits = data.map((json) => Produit.fromJson(json)).toList();
      });
    } else {
      print('Erreur HTTP: ${response.statusCode}');
    }
  } catch (e) {
    print('Erreur réseau ou parsing: $e');
  }
}



  @override
  void initState() {
    super.initState();
    RecupImg();
    fetchProduits();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      setState(() {
        _isAddMenuVisible = !_isAddMenuVisible;
      });
    } else {
      setState(() {
        _selectedIndex = index;
        _isAddMenuVisible = false;
      });
    }
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context);
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              _buildAccueil(),
              _buildProduits(),
              _buildProfil(),
              _buildProgres(),
              _buildProfil(),
            ],
          ),
          if (_isAddMenuVisible)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildFloatingMenu(),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavBarItem(Icons.home, "Accueil", 0),
          _buildNavBarItem(Icons.shopping_bag, "Produits", 1),
          _buildAddItem(),
          _buildNavBarItem(Icons.signal_cellular_alt, "Progrès", 3),
          _buildNavBarItem(Icons.account_circle, "Profil", 4),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          iconSize: 25,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: const Icon(Icons.segment, color: Color.fromARGB(255, 85, 31, 142)),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active),
          onPressed: () {},
        ),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 85, 31, 142)),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: const Color.fromARGB(255, 241, 241, 241),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 20),
                _buildDrawerItem(Icons.home, "Accueil", 0),
                _buildDrawerItem(Icons.person, "Profile", 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color.fromARGB(255, 85, 31, 142),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FormulaireC(title: "Connexion")),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.power_settings_new, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Se Déconnecter', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => _onDrawerItemTapped(index),
    );
  }

  Widget _buildAccueil() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Bonjour!", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const Text("Administrateur", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const Text("Bienvenu sur My App Admin V1", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 205, 205, 205),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (i) {
                return Transform.translate(
                  offset: Offset(0, i == 1 ? -15 : i == 0 ? 0 : 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.stars, size: 40, color: i == 1 ? Colors.amber : i == 2 ? Colors.red : Colors.grey),
                      const SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          image: imageUrls[i].isNotEmpty
                              ? DecorationImage(image: NetworkImage(imageUrls[i]), fit: BoxFit.cover)
                              : null,
                        ),
                        child: imageUrls[i].isEmpty ? const Icon(Icons.error, color: Colors.red) : null,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduits() {
    return produits.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: produits.length,
            itemBuilder: (context, index) {
              final produit = produits[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      produit.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(produit.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${produit.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // TODO: Supprimer un produit
                    },
                  ),
                ),
              );
            },
          );
  }

  Widget _buildProfil() {
    return const Center(child: Text("Page Profile", style: TextStyle(fontSize: 24)));
  }

  Widget _buildProgres() {
    return const Center(child: Text("Page Progrès", style: TextStyle(fontSize: 24)));
  }

  Widget _buildFloatingMenu() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Raccourci', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 25,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _shortcutButton(Icons.add_shopping_cart, "Ajouter", Colors.amber),
              _shortcutButton(Icons.remove_shopping_cart, "Supprimer", Colors.deepOrange),
              _shortcutButton(Icons.manage_accounts, "Utilisateur", Colors.pink),
              _shortcutButton(Icons.inventory, "Stock", Colors.deepPurple),
              _shortcutButton(Icons.settings, "Paramètres", Colors.lightBlue),
              _shortcutButton(Icons.more_horiz, "Autres", Colors.grey.shade300, iconColor: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shortcutButton(IconData icon, String label, Color color, {Color iconColor = Colors.white}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            minimumSize: const Size(40, 55),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _selectedIndex == index ? const Color.fromARGB(255, 85, 31, 142) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: _selectedIndex == index ? Border.all(color: Colors.white, width: 2.0) : null,
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, color: _selectedIndex == index ? Colors.white : Colors.grey),
      ),
      label: label,
    );
  }

  BottomNavigationBarItem _buildAddItem() {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 2, 126),
          borderRadius: BorderRadius.circular(_isAddMenuVisible ? 10 : 20),
        ),
        padding: EdgeInsets.all(_isAddMenuVisible ? 10.0 : 4.0),
        child: Icon(_isAddMenuVisible ? Icons.close : Icons.add, color: Colors.white),
      ),
      label: 'Gérer',
    );
  }
}
