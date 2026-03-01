package servlet;

import dao.UserDAO;
import model.User;
import util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "empty");
            req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
            return;
        }
        email = email.trim().toLowerCase();

        // We always show a success message to avoid user enumeration
        User user = userDAO.findByEmail(email);
        if (user != null) {
            String token = UUID.randomUUID().toString();
            boolean saved = userDAO.setResetToken(email, token);
            if (saved) {
                String baseUrl = req.getScheme() + "://" + req.getServerName()
                        + ":" + req.getServerPort() + req.getContextPath();
                EmailUtil.sendPasswordResetEmail(email, token, baseUrl);
            }
        }

        req.setAttribute("success", "sent");
        req.getRequestDispatcher("/jsp/forgotPassword.jsp").forward(req, resp);
    }
}
