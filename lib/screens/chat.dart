import 'package:flutter/material.dart';

// --- Constantes de Style ---
class AppColors {
  // Le design est principalement blanc/gris clair avec du texte foncé.
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;
  static const Color backgroundColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0); // Ligne de séparation subtile
}

class AppTextStyles {
  static const TextStyle name = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
  );
  static const TextStyle lastMessage = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryTextColor,
  );
  static const TextStyle date = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryTextColor,
  );
}

// -------------------------------------------------------------------
// 1. Modèle de Données
// -------------------------------------------------------------------

/// Représente les données d'une seule conversation.
class Conversation {
  final String name;
  final String lastMessage;
  final String lastActivityDate;
  final String avatarUrl; // Pour les images réelles
  final bool isMuted;
  final int unreadCount;
  final bool isGroupChat;

  Conversation({
    required this.name,
    required this.lastMessage,
    required this.lastActivityDate,
    this.avatarUrl = '', // Placeholder pour l'exemple
    this.isMuted = false,
    this.unreadCount = 0,
    this.isGroupChat = false,
  });
}

// -------------------------------------------------------------------
// 2. Le Widget de la Ligne de Conversation (Composant Réutilisable)
// -------------------------------------------------------------------

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;

  const _ConversationTile({required this.conversation, this.onTap});

  // Pour simuler la photo de profil (utilise le nom comme fallback)
  Widget _buildAvatar() {
    // Si une URL est disponible, utiliser NetworkImage ou CachedNetworkImage
    // Ici, on simule l'image avec un widget circulaire
    if (conversation.avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(conversation.avatarUrl),
      );
    }

    // Gestion des avatars simples (pour les noms longs ou les groupes)
    String initials = conversation.name.split(' ').map((s) => s[0]).join().toUpperCase();
    if (initials.length > 2) {
      initials = initials.substring(0, 2);
    }

    // Pour simuler les photos du design, on utilise une couleur de fond aléatoire
    Color color = Colors.primaries[conversation.name.length % Colors.primaries.length];

    // Pour les chats de groupe, on peut empiler deux avatars (comme "42, Salvatore" dans le design)
    if (conversation.isGroupChat) {
      return SizedBox(
        width: 56, // 2 * radius
        height: 56,
        child: Stack(
          children: [
            const CircleAvatar(
              radius: 20, // Plus petit pour le deuxième
              backgroundColor: Colors.pink,
              child: Icon(Icons.group, color: Colors.white, size: 20),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: color,
                child: Text(initials.substring(0, 1), style: const TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }

    // Avatar standard (Cercle avec couleur de fond et initiales)
    return CircleAvatar(
      radius: 28,
      backgroundColor: color,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

      // --- Avatar (Gauche) ---
      leading: _buildAvatar(),

      // --- Titre et Message (Centre) ---
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(
          conversation.name,
          style: AppTextStyles.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Row(
        children: [
          // Icône muet (si nécessaire, comme dans l'exemple "42 Channel is muted")
          if (conversation.isMuted)
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(Icons.volume_off, size: 14, color: AppColors.secondaryTextColor),
            ),
          Expanded(
            child: Text(
              conversation.lastMessage,
              style: AppTextStyles.lastMessage.copyWith(
                // Rendre le message en gras si non lu (si unreadCount > 0)
                fontWeight: conversation.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                color: conversation.unreadCount > 0 ? AppColors.primaryTextColor : AppColors.secondaryTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      // --- Date et Badge (Droite) ---
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Coche de lecture/distribution (V)
              const Icon(Icons.done_all, size: 14, color: AppColors.secondaryTextColor),
              const SizedBox(width: 4),
              // Date
              Text(
                conversation.lastActivityDate,
                style: AppTextStyles.date,
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Badge de messages non lus (si nécessaire)
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green, // Couleur typique pour les notifications
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          else
          // Placeholder pour aligner la colonne
            const SizedBox(height: 20),
        ],
      ),
    );
  }
}


// -------------------------------------------------------------------
// 3. Le Widget de la Page Principale
// -------------------------------------------------------------------

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  // Données simulées basées sur le design fourni
  List<Conversation> _getChats() {
    return [
      Conversation(
        name: 'Aada Laine',
        lastMessage: 'WWWWWW',
        lastActivityDate: '6/28/2021',
        unreadCount: 1, // Simulation d'un non-lu pour voir le changement de style
      ),
      Conversation(
        name: 'Brown Kid',
        lastMessage: 'a list:',
        lastActivityDate: '6/27/2021',
      ),
      Conversation(
        name: 'Adelle Charles',
        lastMessage: 'Todo bien',
        lastActivityDate: '6/26/2021',
      ),
      Conversation(
        name: '42, Salvatore',
        lastMessage: '👋',
        lastActivityDate: '6/25/2021',
        isGroupChat: true, // Pour tester le stack d'avatars
      ),
      Conversation(
        name: 'Vishal',
        lastMessage: 'hello',
        lastActivityDate: '6/24/2021',
      ),
      Conversation(
        name: 'Abdullah Hadley',
        lastMessage: 'big and tall is the average',
        lastActivityDate: '6/24/2021',
      ),
      Conversation(
        name: 'Abdullah Hadley',
        lastMessage: 'miss metting ok',
        lastActivityDate: '6/24/2021',
      ),
      Conversation(
        name: 'Loki Bright',
        lastMessage: 'File Foto',
        lastActivityDate: '6/22/2021',
      ),
      Conversation(
        name: 'Ana De Armas',
        lastMessage: '😊😊',
        lastActivityDate: '6/22/2021',
      ),
      Conversation(
        name: '42',
        lastMessage: '⚠️ Channel is muted',
        lastActivityDate: '6/16/2021',
        isMuted: true, // Pour tester l'icône muet
      ),
      Conversation(
        name: 'Mario Palmer',
        lastMessage: 'Yo',
        lastActivityDate: '6/14/2021',
      ),
      Conversation(
        name: 'Adelle Charles',
        lastMessage: '👋 Hey',
        lastActivityDate: '6/14/2021',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final chats = _getChats();

    return Scaffold(
      appBar: AppBar(
        // L'AppBar est absente dans le design fourni, mais on pourrait la mettre en place
        // pour la barre de statut (3:41) si elle n'est pas gérée par la `SafeArea`.
        // Pour un design fidèle, on laisse l'écran sans AppBar pour maximiser l'espace.
        toolbarHeight: 0, // Cache la barre d'outils
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.backgroundColor,
          // Utilisation de ListView.separated pour l'efficacité et les séparateurs
          child: ListView.separated(
            itemCount: chats.length,
            // Constructeur de la ligne de conversation
            itemBuilder: (context, index) {
              return _ConversationTile(
                conversation: chats[index],
                onTap: () {
                  debugPrint('Ouvrir la conversation avec ${chats[index].name}');
                },
              );
            },
            // Constructeur du séparateur (la ligne grise fine)
            separatorBuilder: (context, index) {
              // Ajout d'une marge à gauche pour que le séparateur ne passe pas sous l'avatar
              return const Padding(
                padding: EdgeInsets.only(left: 80.0, right: 16.0),
                child: Divider(
                  color: AppColors.dividerColor,
                  height: 0.5,
                  thickness: 0.5,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// 4. Point d'entrée de l'application (Pour la démo)
// -------------------------------------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat List Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        primarySwatch: Colors.blueGrey,
      ),
      home: const ChatListScreen(),
    );
  }
}