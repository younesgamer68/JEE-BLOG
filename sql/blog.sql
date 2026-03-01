-- ==============================================================
--  JEE-Blog  ─  Complete MySQL Setup Script
--  Run this ONCE to create the database, tables and test data.
--  Compatible with MySQL 8.0+
-- ==============================================================

-- 1. Drop & recreate the database (clean slate)
DROP DATABASE IF EXISTS jee_blog;
CREATE DATABASE jee_blog
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE jee_blog;

-- ==============================================================
-- TABLE: users
--   Columns must match UserDAO.mapRow() exactly:
--   id, username, email, password, first_name, last_name,
--   bio, email_validated, validation_token, created_at
-- ==============================================================
CREATE TABLE users (
    id                   INT           NOT NULL AUTO_INCREMENT,
    username             VARCHAR(50)   NOT NULL,
    email                VARCHAR(150)  NOT NULL,
    password             VARCHAR(64)   NOT NULL,
    first_name           VARCHAR(80)   NOT NULL,
    last_name            VARCHAR(80)   NOT NULL,
    bio                  TEXT          NULL,
    filiere              VARCHAR(100)  NULL,
    semester             INT           NOT NULL DEFAULT 0,
    email_validated      TINYINT(1)    NOT NULL DEFAULT 0,
    validation_token     VARCHAR(36)   NULL,
    reset_token          VARCHAR(36)   NULL,
    reset_token_expires  BIGINT        NULL,
    created_at           TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    UNIQUE KEY uq_email    (email),
    UNIQUE KEY uq_username (username),
    INDEX idx_validation_token (validation_token),
    INDEX idx_reset_token      (reset_token)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- UPGRADING an existing DB? Run these ALTER TABLE statements:
-- ALTER TABLE users ADD COLUMN filiere             VARCHAR(100) NULL AFTER bio;
-- ALTER TABLE users ADD COLUMN semester            INT NOT NULL DEFAULT 0 AFTER filiere;
-- ALTER TABLE users ADD COLUMN reset_token         VARCHAR(36) NULL AFTER validation_token;
-- ALTER TABLE users ADD COLUMN reset_token_expires BIGINT NULL AFTER reset_token;

-- ==============================================================
-- TABLE: articles
--   Columns must match ArticleDAO.mapRow() exactly:
--   id, author_id, title, content, created_at, updated_at
-- ==============================================================
CREATE TABLE articles (
    id         INT           NOT NULL AUTO_INCREMENT,
    author_id  INT           NOT NULL,
    title      VARCHAR(255)  NOT NULL,
    content    LONGTEXT      NOT NULL,
    created_at TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP     NULL     DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_author (author_id),
    CONSTRAINT fk_article_author
        FOREIGN KEY (author_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ==============================================================
-- TABLE: comments
--   Columns must match CommentDAO.mapRow() exactly:
--   id, article_id, author_id, content, created_at
-- ==============================================================
CREATE TABLE comments (
    id         INT       NOT NULL AUTO_INCREMENT,
    article_id INT       NOT NULL,
    author_id  INT       NOT NULL,
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_comment_article (article_id),
    INDEX idx_comment_author  (author_id),
    CONSTRAINT fk_comment_article
        FOREIGN KEY (article_id)
        REFERENCES articles(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_comment_author
        FOREIGN KEY (author_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- ==============================================================
-- SAMPLE DATA
--
-- Password for ALL accounts below = "password123"
-- SHA-256("password123") =
-- ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
--
-- email_validated = 1  →  can log in immediately
-- validation_token = NULL → already validated
-- ==============================================================

INSERT INTO users
    (username, email, password, first_name, last_name, bio, email_validated, validation_token)
VALUES
(
    'alice',
    'alice@example.com',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
    'Alice', 'Dupont',
    'Développeuse Java passionnée par Jakarta EE et les applications web.',
    1, NULL
),
(
    'bob',
    'bob@example.com',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
    'Bob', 'Martin',
    'Étudiant en génie informatique à l''EST Agadir.',
    1, NULL
),
(
    'sara',
    'sara@example.com',
    'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
    'Sara', 'Benali',
    'Passionnée de développement web et de nouvelles technologies.',
    1, NULL
);

-- ==============================================================
-- SAMPLE ARTICLES
-- ==============================================================

INSERT INTO articles (author_id, title, content) VALUES
(
    1,
    'Introduction aux Servlets Jakarta EE',
    'Les Servlets sont des composants Java côté serveur qui permettent de traiter des requêtes HTTP et de générer des réponses dynamiques.\n\nElles constituent la base du développement web avec Jakarta EE et fonctionnent à l''intérieur d''un conteneur de servlets comme Apache Tomcat.\n\nDans ce tutoriel, nous allons explorer les concepts fondamentaux des Servlets :\n- Le cycle de vie d''une Servlet (init, service, destroy)\n- La gestion des requêtes GET et POST\n- La redirection et le forwarding\n- La gestion des sessions HTTP\n\nAvec Jakarta EE 10, toutes les classes utilisent le package jakarta.servlet.* au lieu de l''ancien javax.servlet.*.'
),
(
    1,
    'JSP et JSTL : les bases',
    'Les JavaServer Pages (JSP) permettent de créer des vues dynamiques en mélangeant HTML et Java.\n\nLa JSTL (JSP Standard Tag Library) offre un ensemble de tags réutilisables pour simplifier le code JSP et éviter les scriptlets.\n\nExemples de tags JSTL :\n- <c:forEach> pour les boucles\n- <c:if> pour les conditions\n- <c:choose>, <c:when>, <c:otherwise> pour les conditions multiples\n- <fmt:message> pour l''internationalisation\n- <fmt:formatDate> pour le formatage des dates\n\nL''utilisation de JSTL rend le code JSP beaucoup plus propre et maintenable.'
),
(
    2,
    'Internationalisation avec Java ResourceBundle',
    'Pour proposer votre application en plusieurs langues, Java met à disposition la classe ResourceBundle.\n\nPrincipe de fonctionnement :\n1. Créer des fichiers .properties pour chaque langue (messages_fr.properties, messages_en.properties)\n2. Charger le bon bundle selon la locale choisie\n3. Utiliser les clés dans vos JSP avec JSTL <fmt:message>\n\nDans notre blog, le changement de langue est stocké en session et appliqué via le LanguageServlet.\n\nExemple :\nmessages_fr.properties : nav.home=Accueil\nmessages_en.properties : nav.home=Home'
),
(
    3,
    'Architecture MVC avec Jakarta EE',
    'L''architecture MVC (Modèle-Vue-Contrôleur) est un patron de conception fondamental pour les applications web.\n\nDans un projet Jakarta EE :\n- Modèle (Model) : Classes Java dans le package model/ (User, Article, Comment)\n- Vue (View) : Pages JSP dans webapp/jsp/\n- Contrôleur (Controller) : Servlets dans le package servlet/\n\nLe flux typique d''une requête :\n1. Le navigateur envoie une requête HTTP\n2. Le Servlet (contrôleur) reçoit la requête\n3. Il appelle le DAO pour accéder aux données\n4. Il place les données dans la requête (setAttribute)\n5. Il forward vers la JSP appropriée\n6. La JSP génère le HTML et le renvoie au navigateur\n\nCette séparation des responsabilités rend le code plus maintenable et testable.'
),
(
    2,
    'Gestion des sessions HTTP en Jakarta EE',
    'La gestion des sessions est essentielle pour maintenir l''état entre les requêtes HTTP qui sont, par nature, sans état (stateless).\n\nEn Jakarta EE, on utilise HttpSession :\n\nCréer/obtenir une session :\nHttpSession session = request.getSession(true);\n\nStocker un objet en session :\nsession.setAttribute("currentUser", user);\n\nRécupérer un objet de la session :\nUser user = (User) session.getAttribute("currentUser");\n\nDétruire la session (logout) :\nsession.invalidate();\n\nDans notre blog, la session stocke l''objet User connecté, ce qui permet à toutes les pages de savoir qui est connecté.'
);

-- ==============================================================
-- SAMPLE COMMENTS
-- ==============================================================

INSERT INTO comments (article_id, author_id, content) VALUES
(1, 2, 'Excellent article ! Très clair pour les débutants. J''ai enfin compris le cycle de vie des Servlets.'),
(1, 3, 'Merci pour cette introduction. Est-ce que tu peux faire un article sur les Filters Jakarta EE ?'),
(1, 1, 'Bonne idée Sara ! Je prépare un article sur les Filters et les Listeners prochainement.'),
(2, 3, 'La JSTL c''est vraiment pratique. J''utilisais des scriptlets avant, c''est tellement plus propre avec les tags.'),
(2, 1, 'Exactement ! Les scriptlets sont à éviter dans un projet professionnel.'),
(3, 1, 'Super explication du ResourceBundle. Notre blog utilise exactement cette approche pour le FR/EN.'),
(3, 3, 'J''ai implémenté ça dans mon projet, ça marche parfaitement. Merci Bob !'),
(4, 2, 'L''architecture MVC est vraiment le point de départ de tout projet web sérieux.'),
(4, 3, 'Article très complet. Le diagramme du flux de requête est très utile pour visualiser le processus.'),
(5, 1, 'La gestion des sessions est souvent négligée par les débutants. Bon rappel !'),
(5, 3, 'Attention aussi à la durée de vie des sessions et à la sécurité (fixation de session, etc.).');

-- ==============================================================
-- VERIFICATION — run these SELECTs to confirm everything is OK
-- ==============================================================

SELECT 'USERS TABLE' AS check_table;
SELECT id, username, email, first_name, last_name, email_validated FROM users;

SELECT 'ARTICLES TABLE' AS check_table;
SELECT a.id, a.title, u.username AS author, a.created_at
FROM articles a JOIN users u ON a.author_id = u.id;

SELECT 'COMMENTS TABLE' AS check_table;
SELECT c.id, c.content, u.username AS author, a.title AS on_article
FROM comments c
JOIN users u ON c.author_id = u.id
JOIN articles a ON c.article_id = a.id;

