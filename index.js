const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const app = express();
const port = 3000;


app.use(bodyParser.json());

// Configuration de la connexion à MySQL
const db = mysql.createConnection({
  host: '10.50.0.24',
  user: 'mathis1',
  password: 'XXKa7TF1B6N0B94E',
  database: 'seiko_craft'
});

// Connexion à MySQL
db.connect( (err) => {
  if (err) {
    console.error('Erreur de connexion à MySQL:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL');
  console.log(`Vous êtes connecté à la base de données gestion_mathis.`);
  console.log(`Connecter vous au PHPmyadmin http://10.50.0.24/phpmyadmin`);
});

// Routes pour gérer les demandes
app.get('/demande', (req, res) => {
  const sql = 'SELECT * FROM `demande-i`';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});

app.post('/demande', async (req, res) => {
  const { nom, prenom, email, password, motifDemande } = req.body;

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    const sql = 'INSERT INTO `demande-i` (nom, prenom, email, password, motifDemande, status) VALUES (?, ?, ?, ?, ?, ?)';
    db.query(sql, [nom, prenom, email, hashedPassword, motifDemande, 'En attente'], (err, result) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.json({ 
        id: result.insertId, 
        nom, 
        prenom, 
        email, 
        motifDemande, 
        status: 'En attente' 
      });
    });
  } catch (err) {
    res.status(500).send('Erreur lors du hashage du mot de passe');
  }
});

// Routes pour gérer la connexion
app.post('/connexion', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email et mot de passe requis' });
  }
  const sql = 'SELECT * FROM `utilisateur` WHERE email = ?';
  db.query(sql, [email], async (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    if (results.length === 0) {
      return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
    }

    const utilisateur = results[0];

    bcrypt.compare(password, utilisateur.password, (err, result) => {
      if (err) {
        return res.status(500).send(err);
      }
      if (!result) {
        return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
      }

      res.json({ message: 'Connexion réussie', utilisateur });

    });
  });
});

// test le podium 
app.get('/podium/:id', (req, res) => {
  const id = req.params.id;

  if (isNaN(id)) {
    return res.status(400).json({ error: 'ID invalide' });
  }

  const sql = 'SELECT image_url FROM product WHERE id_podium = ?';

  db.query(sql, [id], (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});


app.get('/product/:id', (req, res) => {
  const id = parseInt(req.params.id);

  if (![1, 2, 3].includes(id)) {
    return res.status(400).json({ message: 'id_podium doit être 1, 2 ou 3' });
  }

  const sql = 'SELECT image_url FROM product WHERE id_podium = ?';

  db.query(sql, [id], (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Erreur serveur', error: err });
    }

    if (results.length === 0) {
      return res.status(404).json({ message: 'Aucun produit trouvé pour cet id_podium' });
    }

    res.json(results);
  });
});


// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur API en écoute sur http://localhost:${port}`);
});
