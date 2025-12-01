import 'package:flutter/material.dart';

// --- Constantes de Style (Pour une maintenance facile) ---
class AppColors {
  static const Color primaryColor = Color(0xFF880E4F); // Couleur d'arrière-plan des cartes
  static const Color accentColor = Color(0xFFFFFFFF); // Couleur des icônes et du texte
  static const Color headerColor = Color(0xFF333333); // Couleur du texte des en-têtes
  static const Color backgroundColor = Color(0xFFF5F5F5); // Fond général (légèrement grisé)
}

class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.headerColor,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    color: AppColors.accentColor,
    fontWeight: FontWeight.w600,
  );
}// -------------------------------------------------------------------
// 2. Le Widget de la Carte (Composant Réutilisable)
// -------------------------------------------------------------------

/// Un widget réutilisable pour afficher une carte de la grille.
class _GridCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _GridCard({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Utilisation d'un InkWell pour un feedback visuel au tap
    return InkWell(
      onTap: onTap ?? () => debugPrint('Card tapped: $title'),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          // Note: On pourrait ajouter des BorderRadius pour des coins arrondis
          // borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icône
            Icon(
              icon,
              size: 48,
              color: AppColors.accentColor,
            ),
            const SizedBox(height: 10),
            // Titre
            Text(
              title,
              style: AppTextStyles.cardTitle,
              textAlign: TextAlign.center,
              // Pour gérer les titres longs
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 3. Le Widget de la Page d'Accueil Principale
// -------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
    HomeScreen({super.key});

  // Séparation des données de la présentation (Meilleure pratique)
  final List<Map<String, dynamic>> gridData1 = [
    {'icon': Icons.edit, 'title': 'title'},
    {'icon': Icons.description, 'title': 'title2'},
    {'icon': Icons.mail_outline, 'title': 'title3'}, // Icône différente mais proche
    {'icon': Icons.mail_outline, 'title': 'title4'},
  ];

  final List<Map<String, dynamic>> gridData2 = [
    // Remplacer ces icônes par celles du design si elles sont disponibles dans Icons
    {'icon': Icons.laptop_chromebook, 'title': 'Autre 1'},
    {'icon': Icons.receipt, 'title': 'Autre 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // L'AppBar du design a une couleur de fond (mauve foncé/bordeaux)
        backgroundColor: AppColors.primaryColor,
        // Éléments de l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.accentColor),
          onPressed: () {},
        ),
        title: const Text(
          'Home title',
          style: TextStyle(color: AppColors.accentColor),
        ),
        // Le "LTE/DEBUG" en haut à droite n'est pas un élément standard de l'AppBar
        // mais est une information de statut de l'appareil/mode debug.
      ),
      // Utilisation de ListView pour permettre le défilement si le contenu dépasse la taille de l'écran
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          // --- Section 1 ---
          const _Header(text: 'HEADER 1'),
          const SizedBox(height: 10),
          _buildGrid(context, gridData1),

          const SizedBox(height: 30), // Espace entre les sections

          // --- Section 2 ---
          const _Header(text: 'HEADER 2'),
          const SizedBox(height: 10),
          _buildGrid(context, gridData2),

          // Ajouter plus de contenu si nécessaire
        ],
      ),
    );
  }

  /// Fonction utilitaire pour construire la grille de cartes.
  Widget _buildGrid(BuildContext context, List<Map<String, dynamic>> data) {
    // Utilisation de GridView.count pour une grille à colonnes fixes (2 colonnes ici)
    return GridView.count(
      // Important pour l'imbrication dans un ListView
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true, // Important pour l'imbrication
      crossAxisCount: 2, // 2 colonnes comme dans le design
      crossAxisSpacing: 16.0, // Espace horizontal
      mainAxisSpacing: 16.0, // Espace vertical
      childAspectRatio: 1.0, // Pour s'assurer que les cartes sont carrées ou presque (1.0 donne un carré)
      children: data.map((item) {
        return _GridCard(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          // Vous pouvez passer une fonction onTap spécifique ici
          onTap: () {
            debugPrint('Navigating to ${item['title']} screen');
          },
        );
      }).toList(),
    );
  }
}

// -------------------------------------------------------------------
// 4. Le Widget de l'En-tête de Section (Composant Réutilisable)
// -------------------------------------------------------------------

class _Header extends StatelessWidget {
  final String text;

  const _Header({required this.text});

  @override
  Widget build(BuildContext context) {
    // Utilisation d'un Padding pour le centrage visuel du texte
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        text,
        style: AppTextStyles.header,
      ),
    );
  }
}