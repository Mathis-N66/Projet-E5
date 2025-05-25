DELIMITER $$
DROP PROCEDURE IF EXISTS `verifie`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifie` (IN `demandeId` INT)   BEGIN
    -- Modifier le statut de la personne spécifiée en "Vérifié"
    UPDATE `demande-i`
    SET `status` = 'Vérifié'
    WHERE `idDemande` = demandeId;
END$$

DELIMITER ;

DROP TABLE IF EXISTS `categorie`;
CREATE TABLE IF NOT EXISTS `categorie` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `URLimage` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`),
  UNIQUE KEY `idx_nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `categorie` (`id`, `nom`, `URLimage`) VALUES
(1, 'SEIKOLUS', 'https://seiko-mods.fr/cdn/shop/files/Seikolus_Tiffany__1.jpg?v=1696857930&width=535'),
(2, 'SEIKOYATCH', 'https://seiko-mods.fr/cdn/shop/files/Seikoyacht_argent_1.jpg?v=1696857422&width=535'),
(3, 'SEIKONA', 'https://seiko-mods.fr/cdn/shop/collections/Seikona_blue__1.png?v=1690563275&width=535'),
(4, 'SEIKOMASTER', 'https://seiko-mods.fr/cdn/shop/files/129D3777-9557-404B-A188-09AB6A5BFA15.jpg?v=1696855380&width=535'),
(5, 'SEIKOJUST', 'https://seiko-mods.fr/cdn/shop/files/seikojust_arabic_violet__1.jpg?v=1691507671&width=535'),
(6, 'SEIKONER', 'https://seiko-mods.fr/cdn/shop/files/D6EF5D35-165D-4743-9439-24B4704232E2.jpg?v=1698056936&width=535'),
(7, 'SEIKO GMT', 'https://seiko-mods.fr/cdn/shop/files/Seiko_GMT_Batman_1.jpg?v=1690902716&width=535'),
(8, 'SEIKONAUT', 'https://seiko-mods.fr/cdn/shop/collections/Seikonaut_orange_1.jpg?v=1697481461&width=535');


DROP TABLE IF EXISTS `demande-i`;
CREATE TABLE IF NOT EXISTS `demande-i` (
  `idDemande` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `motifDemande` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `dateDemande` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('En attente','Vérifié') DEFAULT 'En attente',
  PRIMARY KEY (`idDemande`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `demande-i` (`idDemande`, `nom`, `prenom`, `email`, `password`, `motifDemande`, `dateDemande`, `status`) VALUES
(1, 'admin', 'admin', 'admin', '$2b$10$In8RCsCUl2TSjvUNXlNlBuHptIKklmUYIfrGBjpwnzTxlOkaXIBmS', 'admin', '2025-01-20 15:53:47', 'Vérifié'),
(2, 'sabi', 'sofia', 'zegmailm.com', '$2b$10$j3QheurCBKRIMG4DxPJWYOkgfyGvHJhLDqUDwVM8Cv7bDSMad.epq', '(((((', '2025-01-22 08:03:45', 'Vérifié');

DROP TRIGGER IF EXISTS `ajouter_utilisateur`;
DELIMITER $$
CREATE TRIGGER `ajouter_utilisateur` AFTER UPDATE ON `demande-i` FOR EACH ROW BEGIN
    -- Vérifie si le statut a changé en "Vérifié"
    IF NEW.status = 'Vérifié' AND OLD.status != 'Vérifié' THEN
        -- Ajoute l'utilisateur dans la table `utilisateur`
        INSERT INTO `utilisateur-admin` (`nom`, `prenom`, `email`, `password`, `idRole`, `dateCreation`, `idDemande`)
        VALUES (NEW.nom, NEW.prenom, NEW.email, NEW.password, 1, NOW(), NEW.idDemande);  -- Vous pouvez ajuster l'idRole en fonction du rôle de l'utilisateur (par exemple, 1 pour un utilisateur simple)
    END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `deplacer_demande`;
DELIMITER $$
CREATE TRIGGER `deplacer_demande` AFTER UPDATE ON `demande-i` FOR EACH ROW BEGIN
    -- Vérifie si le statut est passé à "Vérifié" et que la demande a été mise à jour depuis plus de 15 minutes
    IF NEW.status = 'Vérifié' AND TIMESTAMPDIFF(MINUTE, NEW.dateDemande, NOW()) >= 5 THEN
        -- Déplace la demande dans la table log_demande
        INSERT INTO `log_demande` (`idDemande`, `idUtilisateur`, `nom`, `prenom`, `email`, `motifDemande`, `status`, `dateDemande`, `dateArchivage`)
        SELECT NEW.idDemande, u.idUtilisateur, NEW.nom, NEW.prenom, NEW.email, NEW.motifDemande, NEW.status, NEW.dateDemande, NOW()
        FROM `utilisateur-admin` u
        WHERE u.email = NEW.email;
        
        -- Supprime la demande de la table demande-i
        DELETE FROM `demande-i` WHERE `idDemande` = NEW.idDemande;
    END IF;
END
$$
DELIMITER ;


DROP TABLE IF EXISTS `log_demande`;
CREATE TABLE IF NOT EXISTS `log_demande` (
  `idLog` int NOT NULL AUTO_INCREMENT,
  `idDemande` int NOT NULL,
  `idUtilisateur` int NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `motifDemande` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` enum('En attente','Vérifié') DEFAULT 'En attente',
  `dateDemande` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `dateArchivage` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idLog`),
  KEY `idDemande` (`idDemande`),
  KEY `idUtilisateur` (`idUtilisateur`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `stock` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_podium` tinyint(1) DEFAULT NULL,
  `categorie` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_product_categorie` (`categorie`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;


INSERT INTO `product` (`id`, `name`, `description`, `price`, `image_url`, `stock`, `created_at`, `id_podium`, `categorie`) VALUES
(1, 'SKX007 Marine Master Mod', 'Modification Marine Master avec cadran saphir', 899.00, 'https://seiko-mods.fr/cdn/shop/files/129D3777-9557-404B-A188-09AB6A5BFA15.jpg?v=1696855380&width=535', 10, '2024-11-28 09:12:30', NULL, 4),
(2, 'SRPD Vintage Diver', 'Style vintage avec insert céramique', 699.00, 'https://seiko-mods.fr/cdn/shop/files/seikojust_arabic_violet__1.jpg?v=1691507671&width=535', 15, '2024-11-28 09:12:30', NULL, 5),
(3, 'SKX013 Explorer Mod', 'Version Explorer avec cadran personnalisé', 799.00, 'https://seiko-mods.fr/cdn/shop/files/D6EF5D35-165D-4743-9439-24B4704232E2.jpg?v=1698056936&width=713', 2, '2024-11-28 09:12:30', 3, 8),
(4, 'Seiko Turtle PADI Edition', 'Édition spéciale PADI avec lunette Pepsi', 1150.00, 'https://tse3.mm.bing.net/th?id=OIP.xLO1BQ12Aj61WNvEYSxx2wHaJ4&pid=Api', 12, '2024-11-28 08:12:30', NULL, 4),
(5, 'Seiko Samurai Save the Ocean', 'Samurai avec cadran inspiré de l’océan', 690.00, 'https://tse1.mm.bing.net/th?id=OIP.MN7HXjiIkcbuldYD0FHYogHaJ4&pid=Api', 10, '2024-11-28 08:12:30', NULL, 3),
(6, 'Seiko Alpinist Green Dial', 'Cadran vert iconique et boussole intégrée', 700.00, 'https://tse4.mm.bing.net/th?id=OIP._jNhE1kF1jNAZ5RGow_UGQHaEi&pid=Api', 9, '2024-11-28 08:12:30', NULL, 8),
(7, 'Seiko Presage Cocktail Time', 'Élégance japonaise inspirée des cocktails', 500.00, 'https://tse1.mm.bing.net/th?id=OIP.whqOo0CVMGAOw_Wv3lcwfgHaHa&pid=Api', 14, '2024-11-28 08:12:30', NULL, 1),
(8, 'SEIKOYATCH RAINBOW', 'Look agressif avec un boîtier noir mat', 680.00, 'https://seiko-mods.fr/cdn/shop/files/IMG-5534.heic?v=1706795059&width=713', 0, '2024-11-28 08:12:30', 1, 6),
(9, 'Seiko 5 Sports GMT Pepsi', 'Fonction GMT avec lunette rouge et bleue', 450.00, 'https://tse1.mm.bing.net/th?id=OIP.R_g1H3mroRYl_5VKOnR9zwHaFl&pid=Api', 20, '2024-11-28 08:12:30', NULL, 7),
(10, 'Seiko SKX009 Pepsi', 'La légendaire plongeuse SKX avec lunette Pepsi', 750.00, 'https://seiko-mods.fr/cdn/shop/files/Seiko_GMT_Pepsi_1.jpg?v=1690902779&width=360', 1, '2024-11-28 08:12:30', 2, 7),
(11, 'Seiko King Turtle Manta Ray', 'Édition spéciale avec motif raie manta', 580.00, 'https://tse1.mm.bing.net/th?id=OIP.xEWmBUiqReEmN-ol1mbl6AHaHa&pid=Api', 13, '2024-11-28 08:12:30', NULL, 4),
(12, 'Seiko Sumo Blue Ocean', 'Un bleu profond inspiré de l’océan', 1360.00, 'https://tse2.mm.bing.net/th?id=OIP.GcqBxM5c9PWqGyLADNF8uQHaE7&pid=Api', 7, '2024-11-28 08:12:30', NULL, 6),
(13, 'Seiko SRPE Military Field', 'Style militaire avec cadran kaki', 400.00, 'https://tse1.mm.bing.net/th?id=OIP._7Lh5xxYz6Cvoy8G4TQLKwHaJn&pid=Api', 18, '2024-11-28 08:12:30', NULL, 3),
(14, 'Seiko Prospex Solar Chrono', 'Chronographe solaire précis et robuste', 650.00, 'https://tse3.mm.bing.net/th?id=OIP.N_cEzhGxBBiABeKIXULr7wHaHa&pid=Api', 16, '2024-11-28 08:12:30', NULL, 2);

DROP TRIGGER IF EXISTS `Maj_idpodium_enfonction`;
DELIMITER $$
CREATE TRIGGER `Maj_idpodium_enfonction` BEFORE UPDATE ON `product` FOR EACH ROW BEGIN
    IF NEW.stock = 0 THEN
        SET NEW.id_podium = 1;
    ELSEIF NEW.stock = 1 THEN
        SET NEW.id_podium = 2;
    ELSEIF NEW.stock = 2 THEN
        SET NEW.id_podium = 3;
    ELSE
        SET NEW.id_podium = NULL;
    END IF;
END
$$
DELIMITER ;

DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `libelle` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `role` (`id`, `libelle`) VALUES
(1, 'Administrateur'),
(2, 'Client');

DROP TABLE IF EXISTS `utilisateur`;
CREATE TABLE IF NOT EXISTS `utilisateur` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `mdp` varchar(256) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `idRole` int DEFAULT '2',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idRole` (`idRole`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `utilisateur` (`id`, `email`, `mdp`, `nom`, `prenom`, `idRole`) VALUES
(1, 'matartcha@gmail.com', '$2y$10$o9tZdQUrO07AJd3uX.ZEA.NaAsQ8zb1ojv9m1ETyxAsLsw.HXaUDi', 'nene', 'mathis', NULL),
(3, 'matartchaqqqq@gmail.com', '$2y$10$1Zjvj2lAjYhNcVOeOfX5fOKSHwr48j.Llj/YnAivVMeX6lcpBxHE2', 'nene', 'mathis', NULL),
(4, 'matartssdacha@gmail.com', '$2y$10$QIrSum3yUANuqQf09Lci3O277ORrmX/fL9Qq5jlMgnbVdjkyTv2d6', 'nene', 'mathis', NULL),
(5, 'matartc020ha@gmail.com', '$2y$10$1pYrg8SB8r4MJbY/Ke5Sz.1hnpRKU2NMxsYuhjq91z7o2f9Ya2LdK', 'nene', 'mathis', NULL);

DROP TABLE IF EXISTS `utilisateur-admin`;
CREATE TABLE IF NOT EXISTS `utilisateur-admin` (
  `idUtilisateur` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `idRole` int NOT NULL DEFAULT '1',
  `dateCreation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idDemande` int DEFAULT NULL,
  PRIMARY KEY (`idUtilisateur`),
  UNIQUE KEY `email` (`email`),
  KEY `idRole` (`idRole`),
  KEY `fk_utilisateur_demande` (`idDemande`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `utilisateur-admin` (`idUtilisateur`, `nom`, `prenom`, `email`, `password`, `idRole`, `dateCreation`, `idDemande`) VALUES
(1, 'admin', 'admin', 'admin', '$2b$10$In8RCsCUl2TSjvUNXlNlBuHptIKklmUYIfrGBjpwnzTxlOkaXIBmS', 4, '2025-01-20 15:54:15', 1);

ALTER TABLE `product`
  ADD CONSTRAINT `fk_product_categorie` FOREIGN KEY (`categorie`) REFERENCES `categorie` (`id`);

ALTER TABLE `utilisateur`
  ADD CONSTRAINT `utilisateur_ibfk_1` FOREIGN KEY (`idRole`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;
