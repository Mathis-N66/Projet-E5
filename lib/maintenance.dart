import 'package:flutter/material.dart';
import 'accueil.dart';
import 'formulaireC.dart';
import 'formulaireI.dart';
import 'mdp-oublie.dart';
import 'main.dart';

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
      home: const MaintenancePage(title: 'Accueil'),
    );
  }
}

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key, required this.title});

  final String title;

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // Utilisation de Builder pour fournir un contexte qui a accès au Scaffold
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Ouvre le Drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Page d\'accueil'),
              onTap: () {
                // Naviguer vers la page d'accueil
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AccueilPage(title: 'Accueil')),
                );
              },
            ),
            ListTile(
              title: const Text('Page connexion'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FormulaireC(title: 'connexion')),
                );
              },
            ),
            ListTile(
              title: const Text('Page inscription'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FormulaireI(title: 'inscription')),
                );
              },
            ),
            ListTile(
              title: const Text('Page mdp oublie'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MDPoublie(title: 'mdp oublie')),
                );
              },
            ),
            ListTile(
              title: const Text('main'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'main')),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'main')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 94, 237, 86),
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          child: const Text(
                            'Retour',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
        ],
      )
    );
  }
}
