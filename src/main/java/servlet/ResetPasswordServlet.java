package servlet;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    /**
     * GET /reset-password?token=xxx
     * Validates the token and shows the reset form (or an error).
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "invalid_token");
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }

        User user = userDAO.findByResetToken(token.trim());
        if (user == null) {
            req.setAttribute("error", "invalid_token");
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }

        // Token valid — pass it to the form
        req.setAttribute("token", token.trim());
        req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
    }

    /**
     * POST /reset-password
     * Accepts the new password and updates the DB.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String token           = req.getParameter("token");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        if (token == null || token.trim().isEmpty()) {
            req.setAttribute("error", "invalid_token");
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }
        token = token.trim();

        // Validate password
        if (password == null || password.length() < 6) {
            req.setAttribute("error", "short");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "mismatch");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }

        // Check token is still valid
        User user = userDAO.findByResetToken(token);
        if (user == null) {
            req.setAttribute("error", "invalid_token");
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }

        // Hash and save
        String hashed = PasswordUtil.hash(password);
        boolean updated = userDAO.resetPassword(token, hashed);
        if (!updated) {
            req.setAttribute("error", "invalid_token");
            req.getRequestDispatcher("/jsp/resetPassword.jsp").forward(req, resp);
            return;
        }

        // Success — redirect to login with success flash
        resp.sendRedirect(req.getContextPath() + "/login?success=reset_ok");
    }
}
