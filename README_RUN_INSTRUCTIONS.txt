==============================================================
  JEE-Blog  -  README & RUN INSTRUCTIONS
  TP JEE - École Supérieure de Technologie, Agadir
==============================================================

REQUIRED SOFTWARE
-----------------
| Software       | Version (minimum) | Download URL                             |
|----------------|-------------------|------------------------------------------|
| JDK            | 17 or higher      | https://adoptium.net                     |
| Eclipse IDE    | 2023-09 or later  | https://www.eclipse.org/downloads/       |
| Apache Tomcat  | 10.1.x            | https://tomcat.apache.org/download-10.cgi|
| MySQL Server   | 8.0               | https://dev.mysql.com/downloads/mysql/   |
| MySQL Workbench| 8.0 (optional)    | https://dev.mysql.com/downloads/workbench|
| Maven          | 3.9.x             | (bundled with Eclipse, or https://maven.apache.org)|

NOTE: You MUST use Tomcat 10.x because the project uses Jakarta EE 10
(jakarta.* namespace). Tomcat 9.x uses the older javax.* namespace and
will NOT work.

==============================================================
STEP 1 – INSTALL & START MYSQL
==============================================================
1. Download and install MySQL 8.0 from the link above.
2. During setup, set the root password (default used in this project: "root").
3. Make sure the MySQL service is running:
   - Windows: Open "Services" and start "MySQL80"
   - Linux/Mac: sudo systemctl start mysql

==============================================================
STEP 2 – CREATE THE DATABASE & IMPORT THE SQL SCRIPT
==============================================================
Option A – Using MySQL Workbench (GUI)
  1. Open MySQL Workbench and connect to localhost with root / root.
  2. Click File > Open SQL Script.
  3. Browse to:  JEE-Blog/sql/blog.sql
  4. Click the lightning bolt (Execute All).

Option B – Using the terminal
  1. Open a terminal / command prompt.
  2. Run:
       mysql -u root -p < path/to/JEE-Blog/sql/blog.sql
  3. Enter password when prompted (default: root).

Verify the database was created:
  mysql -u root -p
  USE jee_blog;
  SHOW TABLES;
  -- You should see: users, articles, comments

==============================================================
STEP 3 – CONFIGURE THE DATABASE CONNECTION
==============================================================
File: src/main/java/dao/DBConnection.java

  private static final String URL      = "jdbc:mysql://localhost:3306/jee_blog?...";
  private static final String USER     = "root";
  private static final String PASSWORD = "root";   ← Change if yours is different

If your MySQL credentials are different, update USER and PASSWORD
in that file before building.

==============================================================
STEP 4 – CONFIGURE EMAIL (for registration validation)
==============================================================
File: src/main/java/util/EmailUtil.java

  private static final String SMTP_HOST     = "smtp.gmail.com";
  private static final String SMTP_USER     = "your_email@gmail.com";
  private static final String SMTP_PASSWORD = "your_app_password";

To use Gmail:
  1. Enable "2-Step Verification" on your Google Account.
  2. Go to: https://myaccount.google.com/apppasswords
  3. Generate an App Password for "Mail".
  4. Replace SMTP_USER and SMTP_PASSWORD with your Gmail and App Password.

*** DEVELOPMENT FALLBACK ***
If you do NOT configure email, the application still works!
When a user registers, the validation link is printed to the
Tomcat console output like:
  >>> VALIDATION LINK (dev fallback): http://localhost:8080/JEE-Blog/validate?token=xxxx
Copy-paste that URL in your browser to validate the account manually.

==============================================================
STEP 5 – IMPORT PROJECT IN ECLIPSE
==============================================================
1. Open Eclipse IDE.
2. Go to: File > Import > Maven > Existing Maven Projects
3. Browse to the root folder of the project (where pom.xml is).
4. Click Finish.
5. Eclipse will download all Maven dependencies automatically.
   Wait for the build to complete (check Progress view).
6. If Eclipse shows errors on jakarta.* imports, right-click the
   project > Maven > Update Project (Alt+F5) and click OK.

==============================================================
STEP 6 – ADD TOMCAT TO ECLIPSE
==============================================================
1. Window > Preferences > Server > Runtime Environments > Add.
2. Select "Apache Tomcat v10.1".
3. Browse to your Tomcat 10.1 installation directory.
4. Click Finish > Apply and Close.

==============================================================
STEP 7 – DEPLOY ON TOMCAT FROM ECLIPSE
==============================================================
1. In the Eclipse "Servers" view (Window > Show View > Servers):
   - Right-click > New > Server > Apache Tomcat v10.1
2. Right-click the JEE-Blog project > Run As > Run on Server.
3. Select your Tomcat server and click Finish.
4. Eclipse will build the WAR and deploy it automatically.

==============================================================
STEP 8 – BUILD WAR (alternative, without Eclipse)
==============================================================
1. Open a terminal in the project root (where pom.xml is).
2. Run:
       mvn clean package
3. The WAR is created at:   target/JEE-Blog.war
4. Copy JEE-Blog.war to TOMCAT_HOME/webapps/
5. Start Tomcat:
       TOMCAT_HOME/bin/startup.sh    (Linux/Mac)
       TOMCAT_HOME/bin/startup.bat   (Windows)

==============================================================
STEP 9 – ACCESS THE APPLICATION
==============================================================
Open your browser and go to:
  http://localhost:8080/JEE-Blog/

Default port is 8080. If you changed Tomcat's port, adjust accordingly.

==============================================================
DEFAULT TEST ACCOUNTS
==============================================================
Both accounts have the password:  password123

| Username | Email               | Status   |
|----------|---------------------|----------|
| alice    | alice@example.com   | Validated|
| bob      | bob@example.com     | Validated|

To log in with alice: email=alice@example.com, password=password123

==============================================================
APPLICATION FEATURES (as required by the TP PDF)
==============================================================
1. Espace Membres:
   - Registration with email validation
   - Login / Logout with session management
   - Passwords are hashed with SHA-256

2. Gestion des Articles:
   - List all articles (visible to everyone)
   - Add a new article (members only)
   - Edit / Delete own articles
   - Read full article

3. Gestion des Commentaires:
   - Post a comment on any article (members only)
   - Delete own comments

4. Gestion des Profils:
   - View and update first name, last name, bio
   - View own published articles

5. Email Validation:
   - After registration, a validation email is sent
   - Account is locked until email is confirmed
   - Dev fallback: validation link printed to Tomcat console

6. Internationalisation (French + English):
   - Language dropdown in navbar: LANGUES / LANGUAGES
   - Shows: Français / English
   - Language preference stored in HTTP Session
   - All pages respond to the selected language

==============================================================
FREE WEB HOSTING RECOMMENDATION (TP requirement #4)
==============================================================
The following free hosting options support Java/Jakarta EE WAR deployment:

1. Railway.app     https://railway.app          – Supports Docker+Tomcat
2. Render.com      https://render.com           – Free tier with Docker
3. Oracle Cloud    https://www.oracle.com/cloud – Always Free Tier, VM + Tomcat
4. Koyeb           https://koyeb.com            – Supports Docker deployment

RECOMMENDED: Oracle Cloud Always Free Tier
  - Create a free account
  - Create a VM (Ubuntu 22.04)
  - Install JDK 17, Tomcat 10.1, MySQL 8.0
  - Upload your WAR and start Tomcat

==============================================================
PROJECT STRUCTURE SUMMARY
==============================================================
JEE-Blog/
├── pom.xml
├── sql/
│   └── blog.sql
├── src/main/java/
│   ├── dao/
│   │   ├── DBConnection.java
│   │   ├── UserDAO.java
│   │   ├── ArticleDAO.java
│   │   └── CommentDAO.java
│   ├── model/
│   │   ├── User.java
│   │   ├── Article.java
│   │   └── Comment.java
│   ├── servlet/
│   │   ├── RegisterServlet.java
│   │   ├── LoginServlet.java
│   │   ├── LogoutServlet.java
│   │   ├── ArticleServlet.java
│   │   ├── CommentServlet.java
│   │   ├── ProfileServlet.java
│   │   ├── EmailValidationServlet.java
│   │   ├── LanguageServlet.java
│   │   └── HomeServlet.java
│   └── util/
│       ├── PasswordUtil.java
│       └── EmailUtil.java
└── src/main/webapp/
    ├── index.jsp
    ├── css/
    │   └── style.css
    ├── resources/
    │   ├── messages_fr.properties
    │   └── messages_en.properties
    ├── jsp/
    │   ├── header.jsp
    │   ├── footer.jsp
    │   ├── articles.jsp
    │   ├── articleDetail.jsp
    │   ├── addArticle.jsp
    │   ├── login.jsp
    │   ├── register.jsp
    │   ├── emailValidation.jsp
    │   └── profile.jsp
    └── WEB-INF/
        └── web.xml

==============================================================
TECHNOLOGIES USED (as per PDF)
==============================================================
- JDK 17
- Eclipse IDE
- Apache Tomcat 10.1
- Jakarta Servlets (jakarta.servlet.*)
- JSP (JavaServer Pages)
- JSTL 3.0 (fmt, core tag libraries)
- MySQL 8.0
- Bootstrap 5.3 (CDN)
- JavaMail 2.0 (email validation)

==============================================================
CONTACT
==============================================================
TP JEE-Blog – École Supérieure de Technologie, Agadir
Présentation : Lundi 02 Mars 2026
==============================================================
