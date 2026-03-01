package dao;

import java.sql.*;

public class DBConnection {

    private static final String DB_PATH = "C:/JEE-Blog-Data/jee_blog.db";
    private static final String URL     = "jdbc:sqlite:" + DB_PATH;

    static {
        try { Class.forName("org.sqlite.JDBC"); }
        catch (ClassNotFoundException e) { throw new RuntimeException("SQLite JDBC Driver not found", e); }

        new java.io.File("C:/JEE-Blog-Data").mkdirs();

        try (Connection con = DriverManager.getConnection(URL);
             Statement st  = con.createStatement()) {

            st.executeUpdate("PRAGMA foreign_keys = ON;");

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "  id               INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  username         TEXT NOT NULL UNIQUE," +
                "  email            TEXT NOT NULL UNIQUE," +
                "  password         TEXT NOT NULL," +
                "  first_name       TEXT NOT NULL," +
                "  last_name        TEXT NOT NULL," +
                "  bio              TEXT," +
                "  filiere          TEXT DEFAULT ''," +
                "  semester         INTEGER DEFAULT 0," +
                "  email_validated  INTEGER NOT NULL DEFAULT 0," +
                "  validation_token TEXT," +
                "  created_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // Add columns if upgrading from old schema
            try { st.executeUpdate("ALTER TABLE users ADD COLUMN filiere TEXT DEFAULT ''"); } catch(SQLException ignored){}
            try { st.executeUpdate("ALTER TABLE users ADD COLUMN semester INTEGER DEFAULT 0"); } catch(SQLException ignored){}

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS articles (" +
                "  id         INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  author_id  INTEGER NOT NULL," +
                "  title      TEXT NOT NULL," +
                "  content    TEXT NOT NULL," +
                "  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                "  updated_at TIMESTAMP," +
                "  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE" +
                ")"
            );

            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS comments (" +
                "  id         INTEGER PRIMARY KEY AUTOINCREMENT," +
                "  article_id INTEGER NOT NULL," +
                "  author_id  INTEGER NOT NULL," +
                "  content    TEXT NOT NULL," +
                "  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                "  FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE," +
                "  FOREIGN KEY (author_id)  REFERENCES users(id)    ON DELETE CASCADE" +
                ")"
            );

            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM users");
            if (rs.next() && rs.getInt(1) == 0) seedData(con);
            rs.close();

        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize SQLite database", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        Connection con = DriverManager.getConnection(URL);
        try (Statement st = con.createStatement()) { st.execute("PRAGMA foreign_keys = ON;"); }
        return con;
    }

    private static void seedData(Connection con) throws SQLException {
        String pw = "ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f";

        con.createStatement().executeUpdate(
            "INSERT INTO users (username,email,password,first_name,last_name,bio,filiere,semester,email_validated) VALUES" +
            "('alice','alice@example.com','" + pw + "','Alice','Dupont','Développeuse Java passionnée.','Génie Informatique',4,1)," +
            "('bob','bob@example.com','"   + pw + "','Bob','Martin','Étudiant passionné de web.','Réseaux & Télécoms',2,1)," +
            "('sara','sara@example.com','" + pw + "','Sara','Benali','Fan de développement web.','Génie Logiciel',6,1)"
        );

        String[] dates = {
            "2024-01-15","2024-02-03","2024-03-22","2024-04-10","2024-05-18",
            "2024-06-07","2024-07-14","2024-08-29","2024-09-05","2024-10-11",
            "2024-11-20","2024-12-01","2025-01-08","2025-02-14","2025-03-19",
            "2025-04-25","2025-05-30","2025-06-12","2025-07-22","2025-08-09",
            "2025-09-15","2025-10-28","2025-11-03"
        };

        String[][] articles = {
            {"1","Introduction aux Servlets Jakarta EE","Les Servlets sont des composants Java côté serveur. Elles traitent les requêtes HTTP et génèrent des réponses dynamiques. Avec Jakarta EE 10, on utilise le package jakarta.servlet.* au lieu de javax.servlet.*.\n\nLe cycle de vie d'une Servlet comprend trois phases :\n1. init() - appelée une seule fois à l'initialisation\n2. service() - appelée pour chaque requête\n3. destroy() - appelée à la destruction\n\nLes Servlets sont déployées dans un conteneur comme Apache Tomcat qui gère leur cycle de vie automatiquement."},
            {"1","JSP et JSTL : les bases","JavaServer Pages (JSP) permettent de créer des vues dynamiques en combinant HTML et Java.\n\nLa JSTL (JSP Standard Tag Library) fournit des tags réutilisables :\n- <c:forEach> : boucles\n- <c:if> : conditions\n- <fmt:message> : internationalisation\n- <fmt:formatDate> : formatage de dates\n\nL'utilisation de JSTL évite les scriptlets et rend le code plus maintenable et lisible."},
            {"2","Internationalisation avec ResourceBundle","Pour supporter plusieurs langues en Java, on utilise ResourceBundle avec des fichiers .properties.\n\nCréez messages_fr.properties et messages_en.properties dans src/main/resources/.\n\nDans la JSP :\n<fmt:setBundle basename='messages'/>\n<fmt:message key='nav.home'/>\n\nLa langue est stockée en session et changée via un Servlet dédié."},
            {"3","Architecture MVC avec Jakarta EE","Le patron MVC sépare les responsabilités :\n- Modèle : classes Java (User, Article, Comment) + DAO\n- Vue : pages JSP avec JSTL\n- Contrôleur : Servlets\n\nFlux d'une requête :\nNavigateur → Servlet → DAO → Base de données → Servlet → JSP → Navigateur\n\nCette architecture facilite la maintenance, les tests et l'évolution de l'application."},
            {"1","Gestion des sessions HTTP","HttpSession permet de maintenir l'état entre requêtes :\n\nsession.setAttribute('user', user) // stocker\nsession.getAttribute('user')       // récupérer\nsession.invalidate()               // déconnecter\n\nLa durée de vie par défaut est 30 minutes. Pour la sécurité, il faut toujours invalider la session lors du logout et régénérer l'ID de session après authentification."},
            {"2","JDBC et DAO Pattern avec SQLite","Le pattern DAO (Data Access Object) isole la logique d'accès aux données.\n\nAvantages :\n- Séparation des responsabilités\n- Facilite les tests unitaires\n- Permet de changer de base de données sans modifier le code métier\n\nSQLite est idéal pour le développement : zéro configuration, fichier unique, parfait pour les projets académiques."},
            {"3","Sécurité dans les applications Jakarta EE","Les bonnes pratiques de sécurité :\n\n1. Hachage des mots de passe avec SHA-256 ou BCrypt\n2. Validation des entrées côté serveur\n3. Protection contre les injections SQL (PreparedStatement)\n4. Gestion sécurisée des sessions\n5. Validation par email à l'inscription\n6. HTTPS en production\n\nNe jamais faire confiance aux données venant du client !"},
            {"1","Les Filtres Jakarta EE","Les Filters interceptent les requêtes avant qu'elles n'atteignent le Servlet.\n\nUsages courants :\n- Authentification (vérifier si l'utilisateur est connecté)\n- Compression des réponses\n- Logging des requêtes\n- Encodage des caractères\n\nUn Filter implémente jakarta.servlet.Filter et est déclaré via @WebFilter ou dans web.xml."},
            {"2","Déploiement sur Apache Tomcat","Tomcat 10.1 est le serveur de référence pour Jakarta EE :\n\n1. Télécharger Tomcat 10.1 depuis tomcat.apache.org\n2. Configurer le projet Maven avec packaging WAR\n3. Construire avec mvn clean package\n4. Copier le WAR dans webapps/\n5. Démarrer avec bin/startup.sh\n\nIntelliJ IDEA peut déployer directement via la configuration Run/Debug."},
            {"3","Bootstrap 5 avec JSP","Bootstrap 5 s'intègre parfaitement avec JSP via CDN :\n\n<link rel='stylesheet' href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'/>\n\nAvantages :\n- Responsive design automatique\n- Composants prêts à l'emploi\n- Grille 12 colonnes\n- Thème personnalisable\n\nCombinez Bootstrap avec du CSS custom pour un design unique."},
            {"1","Validation de formulaires en Java","La validation côté serveur est indispensable :\n\n// Dans le Servlet\nString email = request.getParameter('email');\nif (email == null || !email.contains('@')) {\n    request.setAttribute('error', 'email_invalid');\n    forward('/jsp/register.jsp');\n    return;\n}\n\nToujours valider côté serveur, même si validation côté client existe."},
            {"2","Pattern Singleton pour DBConnection","Le Singleton garantit une seule instance de connexion :\n\npublic class DBConnection {\n    private static Connection instance;\n    \n    public static synchronized Connection get() {\n        if (instance == null) {\n            instance = DriverManager.getConnection(URL);\n        }\n        return instance;\n    }\n}\n\nAttention aux problèmes de concurrence en environnement multi-thread !"},
            {"3","Les Listeners Jakarta EE","Les Listeners réagissent aux événements du cycle de vie :\n\n- ServletContextListener : démarrage/arrêt de l'application\n- HttpSessionListener : création/destruction de sessions\n- ServletRequestListener : début/fin de requêtes\n\n@WebListener\npublic class AppStartListener implements ServletContextListener {\n    public void contextInitialized(ServletContextEvent e) {\n        // Initialisation au démarrage\n    }\n}"},
            {"1","REST vs Servlet : comparaison","Les Servlets classiques vs API REST :\n\nServlets traditionnels :\n+ Simple à apprendre\n+ Intégré dans Jakarta EE\n- Couplage fort avec HTML\n\nAPI REST avec JAX-RS :\n+ Séparation frontend/backend\n+ Consommable par n'importe quel client\n+ JSON natif\n\nPour un blog académique, les Servlets sont parfaitement adaptés."},
            {"2","Gestion des erreurs en Jakarta EE","Gérer les erreurs proprement :\n\n1. Pages d'erreur custom dans web.xml\n<error-page>\n    <error-code>404</error-code>\n    <location>/jsp/error404.jsp</location>\n</error-page>\n\n2. Try-catch dans les Servlets\n3. Log des erreurs avec java.util.logging\n4. Redirection vers pages d'erreur user-friendly\n\nNe jamais exposer les stack traces à l'utilisateur final !"},
            {"3","Maven pour les projets Jakarta EE","Maven simplifie la gestion des dépendances :\n\npom.xml contient :\n- groupId, artifactId, version\n- packaging: war\n- dependencies: jakarta.servlet-api, JSTL, drivers...\n\nCommandes essentielles :\nmvn clean package    # Compile + crée le WAR\nmvn clean install    # Installe en local\nmvn dependency:tree  # Voir les dépendances\n\nIntelliJ recharge automatiquement les changements Maven."},
            {"1","Internationalisation avancée i18n","Aller plus loin avec l'i18n :\n\n1. Détecter automatiquement la langue du navigateur\n   String lang = request.getLocale().getLanguage();\n\n2. Formater les dates selon la locale\n   <fmt:formatDate value='${date}' dateStyle='long'/>\n\n3. Formater les nombres\n   <fmt:formatNumber value='${price}' type='currency'/>\n\n4. Pluralisation avec MessageFormat\n   MessageFormat.format('{0} article{0,choice,0#s|1#|1<s}', count)"},
            {"2","Upload de fichiers avec Jakarta EE","Gérer l'upload de fichiers :\n\n@MultipartConfig\n@WebServlet('/upload')\npublic class UploadServlet extends HttpServlet {\n    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {\n        Part filePart = req.getPart('file');\n        String fileName = filePart.getSubmittedFileName();\n        filePart.write('/uploads/' + fileName);\n    }\n}\n\nLimiter la taille : @MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB"},
            {"3","Tests avec JUnit pour Jakarta EE","Tester les composants Jakarta EE :\n\n1. Tests unitaires des DAO avec base H2 en mémoire\n2. Tests d'intégration avec Arquillian\n3. Mock des objets HttpServletRequest/Response\n\nExemple avec Mockito :\nHttpServletRequest req = mock(HttpServletRequest.class);\nwhen(req.getParameter('email')).thenReturn('test@test.com');\n\nLes tests garantissent la qualité et facilitent les refactorings."},
            {"1","WebSockets avec Jakarta EE","Communication bidirectionnelle en temps réel :\n\n@ServerEndpoint('/ws/chat')\npublic class ChatEndpoint {\n    @OnOpen\n    public void onOpen(Session session) { ... }\n    \n    @OnMessage\n    public void onMessage(String message, Session session) {\n        // Diffuser à tous les clients connectés\n        broadcast(message);\n    }\n}\n\nTomcat 10 supporte les WebSockets nativement via l'API jakarta.websocket."},
            {"2","Optimisation des performances Tomcat","Optimiser Tomcat pour la production :\n\n1. Compression GZIP\n<Connector compression='on' compressionMinSize='2048'/>\n\n2. Connection pooling avec DBCP\n3. Cache des ressources statiques\n4. Augmenter le heap JVM\nJAVA_OPTS='-Xms512m -Xmx1024m'\n\n5. Désactiver les logs verbose\n6. Utiliser APR/Native pour de meilleures performances réseau\n\nMonitorer avec JConsole ou VisualVM."},
            {"3","Pattern Observer dans les Servlets","Implémenter le pattern Observer avec les Listeners Jakarta EE :\n\nLes Listeners sont des Observers natifs :\n- HttpSessionAttributeListener : observe les changements d'attributs de session\n- ServletContextAttributeListener : observe le contexte global\n\nUtilisation pratique :\n- Compter les utilisateurs connectés\n- Logger les actions importantes\n- Nettoyer les ressources automatiquement\n- Notifier d'autres composants lors d'événements"},
            {"1","Déploiement cloud avec Jakarta EE","Héberger votre application Jakarta EE gratuitement :\n\n1. Oracle Cloud Free Tier\n   - VM Ubuntu + Tomcat 10\n   - Toujours gratuit\n\n2. Railway.app\n   - Déploiement Docker\n   - Simple et rapide\n\n3. Render.com\n   - Support Docker\n   - SSL automatique\n\nÉtapes :\n1. mvn clean package\n2. Copier le WAR\n3. Configurer la DB\n4. Démarrer Tomcat\n\nPensez à sécuriser vos credentials en variables d'environnement !"}
        };

        for (String[] a : articles) {
            int idx = Integer.parseInt(a[0]) - 1;
            String date = dates[idx % dates.length];
            con.createStatement().executeUpdate(
                "INSERT INTO articles (author_id, title, content, created_at) VALUES (" +
                a[0] + ", '" + a[1].replace("'","''") + "', '" + a[2].replace("'","''") + "', '" + date + " 10:00:00')"
            );
        }

        con.createStatement().executeUpdate(
            "INSERT INTO comments (article_id,author_id,content) VALUES" +
            "(1,2,'Excellent article, très bien expliqué !')," +
            "(1,3,'Merci pour cette introduction claire.')," +
            "(2,1,'La JSTL est vraiment indispensable.')," +
            "(3,2,'ResourceBundle fonctionne parfaitement dans mon projet.')," +
            "(4,3,'L architecture MVC m a vraiment aidé à structurer mon code.')," +
            "(5,1,'Session.invalidate() est crucial pour la sécurité.')," +
            "(6,2,'SQLite + JDBC Pattern, combinaison parfaite pour débuter.')," +
            "(7,3,'Très bon rappel sur la sécurité, souvent négligée.')," +
            "(8,1,'Les Filters sont sous-estimés par les débutants.')," +
            "(10,3,'Bootstrap 5 avec JSP, combinaison gagnante !')"
        );

        System.out.println(">>> JEE-Blog: Database seeded with " + articles.length + " articles.");
    }
}
