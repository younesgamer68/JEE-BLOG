package servlet;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Flash success from password reset redirect
        String success = req.getParameter("success");
        if ("reset_ok".equals(success)) {
            req.setAttribute("success", "reset_ok");
        }
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password");

        User user = userDAO.findByEmail(email);

        if (user == null || !PasswordUtil.verify(password, user.getPassword())) {
            req.setAttribute("error", "invalid_credentials");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        if (!user.isEmailValidated()) {
            req.setAttribute("error", "email_not_validated");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);
        resp.sendRedirect(req.getContextPath() + "/articles");
    }
}
