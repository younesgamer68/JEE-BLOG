package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    // =====================================================================
    //  !! CONFIGURED FOR BREVO SMTP !!
    //  1. The host is now Brevo's SMTP relay.
    //  2. SMTP_USER is your registered Brevo email.
    //  3. SMTP_PASSWORD is your Brevo API/SMTP Key.
    // =====================================================================
    private static final String SMTP_HOST     = "smtp-relay.brevo.com";
    private static final int    SMTP_PORT     = 587;
    private static final String SMTP_USER     = "gameryounes68@gmail.com";
    private static final String SMTP_PASSWORD = "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"; // <-- Replace with your NEW key after deleting this one!
    // =====================================================================

    // ----------------------------------------------------------------
    //  ACCOUNT VALIDATION EMAIL  (sent on registration)
    // ----------------------------------------------------------------
    public static void sendValidationEmail(String toEmail, String token, String baseUrl) {
        String subject = "✅ Validation de votre compte JEE-Blog / Account Validation";
        String link    = baseUrl + "/validate?token=" + token;

        String body = "<html><body style=\"font-family:Arial,sans-serif;background:#0d1117;color:#e6edf3;padding:32px\">"
                + "<div style=\"max-width:520px;margin:auto;background:#161b24;border-radius:16px;padding:32px;border:1px solid #30363d\">"
                + "<h2 style=\"color:#3b7dd8;margin-top:0\">🎓 Bienvenue sur JEE-Blog</h2>"
                + "<p>Merci de vous être inscrit(e) sur <strong>JEE-Blog</strong>, la plateforme académique de l'EST Agadir.</p>"
                + "<p>Cliquez sur le bouton ci-dessous pour <strong>valider votre adresse email</strong> :</p>"
                + "<div style=\"text-align:center;margin:28px 0\">"
                + "  <a href=\"" + link + "\" style=\"background:#2563b0;color:#fff;padding:14px 32px;"
                + "     border-radius:10px;text-decoration:none;font-weight:700;font-size:15px\">"
                + "     ✅ Valider mon compte</a>"
                + "</div>"
                + "<p style=\"font-size:13px;color:#8b949e\">Ou copiez ce lien dans votre navigateur :<br>"
                + "<a href=\"" + link + "\" style=\"color:#3b7dd8;word-break:break-all\">" + link + "</a></p>"
                + "<hr style=\"border-color:#30363d;margin:24px 0\"/>"
                + "<p style=\"font-size:12px;color:#8b949e;margin:0\">JEE-Blog • EST Agadir, Maroc • Projet Jakarta EE</p>"
                + "</div></body></html>";

        sendHtmlEmail(toEmail, subject, body,
                ">>> VALIDATION LINK (dev fallback): " + link);
    }

    // ----------------------------------------------------------------
    //  PASSWORD RESET EMAIL  (sent on forgot-password request)
    // ----------------------------------------------------------------
    public static void sendPasswordResetEmail(String toEmail, String token, String baseUrl) {
        String subject = "🔑 Réinitialisation de votre mot de passe JEE-Blog / Password Reset";
        String link    = baseUrl + "/reset-password?token=" + token;

        String body = "<html><body style=\"font-family:Arial,sans-serif;background:#0d1117;color:#e6edf3;padding:32px\">"
                + "<div style=\"max-width:520px;margin:auto;background:#161b24;border-radius:16px;padding:32px;border:1px solid #30363d\">"
                + "<h2 style=\"color:#3b7dd8;margin-top:0\">🔑 Réinitialisation du mot de passe</h2>"
                + "<p>Vous avez demandé la réinitialisation du mot de passe associé à <strong>" + toEmail + "</strong>.</p>"
                + "<p>Cliquez sur le bouton ci-dessous (valable <strong>30 minutes</strong>) :</p>"
                + "<div style=\"text-align:center;margin:28px 0\">"
                + "  <a href=\"" + link + "\" style=\"background:#2563b0;color:#fff;padding:14px 32px;"
                + "     border-radius:10px;text-decoration:none;font-weight:700;font-size:15px\">"
                + "     🔑 Réinitialiser mon mot de passe</a>"
                + "</div>"
                + "<p style=\"font-size:13px;color:#8b949e\">Ou copiez ce lien :<br>"
                + "<a href=\"" + link + "\" style=\"color:#3b7dd8;word-break:break-all\">" + link + "</a></p>"
                + "<p style=\"font-size:13px;color:#e6823a\">⚠️ Si vous n'avez pas fait cette demande, ignorez cet email.</p>"
                + "<hr style=\"border-color:#30363d;margin:24px 0\"/>"
                + "<p style=\"font-size:12px;color:#8b949e;margin:0\">JEE-Blog • EST Agadir, Maroc • Projet Jakarta EE</p>"
                + "</div></body></html>";

        sendHtmlEmail(toEmail, subject, body,
                ">>> PASSWORD RESET LINK (dev fallback): " + link);
    }

    // ----------------------------------------------------------------
    //  Internal helper
    // ----------------------------------------------------------------
    private static void sendHtmlEmail(String toEmail, String subject, String htmlBody, String consoleFallback) {
        Properties props = new Properties();
        props.put("mail.smtp.auth",             "true");
        props.put("mail.smtp.starttls.enable",  "true");
        props.put("mail.smtp.host",             SMTP_HOST);
        props.put("mail.smtp.port",             String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust",        "smtp-relay.brevo.com"); // <-- This must match the Brevo host

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "JEE-Blog EST Agadir"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println(">>> Email sent to: " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(consoleFallback);
        }
    }
}