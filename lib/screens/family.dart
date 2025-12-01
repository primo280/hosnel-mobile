import 'package:flutter/material.dart';

// --- Constantes de Style ---
class AppColors {
  // Couleur d'arrière-plan principale (Violet foncé)
  static const Color primaryBackgroundColor = Color(0xFF331A47);
  // Couleur pour les titres et icônes
  static const Color primaryTextColor = Color(0xFFFFFFFF);
  // Couleur pour les sous-titres et les informations secondaires
  static const Color secondaryTextColor = Color(0xFFCCCCCC);
  // Couleur des cartes (légèrement plus claire ou même couleur que le fond pour l'effet)
  static const Color cardColor = Color(0xFF4C3364); 
  // Couleurs d'accentuation pour les icônes (si besoin)
  static const Color iconAccentColor = Color(0xFFFF4081); // Pour le pin de localisation
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
  );
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.secondaryTextColor,
  );
  static const TextStyle cardMainText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
  );
  static const TextStyle cardDetailText = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryTextColor,
  );
  static const TextStyle cardItemCount = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
  );
}

// -------------------------------------------------------------------
// 1. Modèle de Données (Séparation des préoccupations)
// -------------------------------------------------------------------

// Énumération pour identifier le type de carte (si une logique spécifique est nécessaire)
enum CardType { calendar, groceries, locations, activity, todo, settings }

/// Représente les données d'une carte sur le tableau de bord.
class DashboardItem {
  final CardType type;
  final String mainTitle;
  final String detailLine1;
  final String detailLine2;
  final Widget? iconWidget; // Accepte un widget complexe comme le calendrier
  final Color cardColor;

  DashboardItem({
    required this.type,
    required this.mainTitle,
    required this.detailLine1,
    required this.detailLine2,
    this.iconWidget,
    this.cardColor = AppColors.cardColor,
  });
}

// -------------------------------------------------------------------
// 2. Point d'entrée de l'application (Pour la démo)
// -------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Family Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryBackgroundColor,
          elevation: 0,
        ),
      ),
      home: const DashboardScreen(),
    );
  }

  void _handleCardTap(BuildContext context, DashboardItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vous avez sélectionné "${item.mainTitle}".'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// -------------------------------------------------------------------
// 3. Le Widget de la Carte (Composant Réutilisable)
// -------------------------------------------------------------------

class _DashboardCard extends StatelessWidget {
  final DashboardItem item;
  final VoidCallback? onTap;

  const _DashboardCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: item.cardColor,
      elevation: 4.0, // Petite élévation pour un effet de superposition
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        // Feedback tactile
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap ?? () => debugPrint('${item.mainTitle} tapped.'),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Icône / Widget personnalisé (en haut à gauche)
              Align(
                alignment: Alignment.topLeft,
                child: item.iconWidget ?? const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 10),

              // Titre principal
              Text(
                item.mainTitle,
                style: AppTextStyles.cardMainText,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Détail 1 (Sous-titre)
              Text(
                item.detailLine1,
                style: AppTextStyles.cardDetailText,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Détail 2 (Compteur d'éléments)
              Text(
                item.detailLine2,
                style: AppTextStyles.cardItemCount,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 4. Widget pour l'Icône de Calendrier Spécifique
// -------------------------------------------------------------------

/// Crée l'icône complexe avec la date '23' sur un fond blanc/gris.
class _CalendarIcon extends StatelessWidget {
  const _CalendarIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primaryTextColor, // Fond blanc
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // Bandelette supérieure du calendrier
          // Note: Flutter Icons.calendar_today n'a pas cet aspect exactement.
          // Simulation simple:
          Text(
            '23',
            style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 22
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------
// 5. Le Widget de la Page Principale
// -------------------------------------------------------------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Construction des données du tableau de bord
  List<DashboardItem> _getDashboardItems() {
    return [
      DashboardItem(
        type: CardType.calendar,
        mainTitle: 'Calendar',
        detailLine1: 'March, Wednesday',
        detailLine2: '3 Events',
        iconWidget: const _CalendarIcon(),
      ),
      DashboardItem(
        type: CardType.groceries,
        mainTitle: 'Groceries',
        detailLine1: 'Bocali, Apple',
        detailLine2: '4 Items',
        iconWidget: const Icon(Icons.shopping_basket, size: 50, color: Colors.green),
      ),
      DashboardItem(
        type: CardType.locations,
        mainTitle: 'Locations',
        detailLine1: 'Lucy Mao going to Office',
        detailLine2: '2 Locations Tracked', // Remplacé par un texte cohérent
        // Icône de localisation complexe (simulée avec Stack)
        iconWidget: const Icon(Icons.location_on, size: 50, color: AppColors.iconAccentColor),
      ),
      DashboardItem(
        type: CardType.activity,
        mainTitle: 'Activity',
        detailLine1: 'Rose favorited your Post',
        detailLine2: '5 New Notifications', // Remplacé par un texte cohérent
        // Icône d'activité (simulée avec un feu d'artifice/étoile)
        iconWidget: const Icon(Icons.star, size: 50, color: Colors.yellow),
      ),
      DashboardItem(
        type: CardType.todo,
        mainTitle: 'To do',
        detailLine1: 'Homework, Design',
        detailLine2: '4 Items',
        iconWidget: const Icon(Icons.check_box_outlined, size: 50, color: Colors.lightGreen),
      ),
      DashboardItem(
        type: CardType.settings,
        mainTitle: 'Settings',
        detailLine1: 'Security, Notifications', // Remplacé par un texte cohérent
        detailLine2: '2 Items',
        iconWidget: const Icon(Icons.settings, size: 50, color: Colors.deepPurpleAccent),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _getDashboardItems();

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      // Pas d'AppBar pour le design, mais un statut bar
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- En-tête de l'écran ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Family',
                        style: AppTextStyles.screenTitle,
                      ),
                      Text(
                        'Home',
                        style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  // Icône de notification (Enveloppe ou Message)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      const Icon(Icons.email, size: 30, color: AppColors.primaryTextColor),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                        child: const Text(
                          '1',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Grille des cartes ---
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Deux colonnes
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.95, // Ajustement pour que la hauteur soit un peu plus grande que la largeur
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _DashboardCard(item: items[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}