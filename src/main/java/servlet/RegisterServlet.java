package servlet;

import dao.UserDAO;
import model.User;
import util.EmailUtil;
import util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username  = req.getParameter("username").trim();
        String email     = req.getParameter("email").trim();
        String password  = req.getParameter("password");
        String firstName = req.getParameter("firstName").trim();
        String lastName  = req.getParameter("lastName").trim();
        String bio       = req.getParameter("bio") != null ? req.getParameter("bio").trim() : "";
        String filiere   = req.getParameter("filiere") != null ? req.getParameter("filiere").trim() : "";
        int semester     = 0;
        try { semester = Integer.parseInt(req.getParameter("semester")); } catch (Exception ignored) {}

        if (username.isEmpty() || email.isEmpty() || password.isEmpty() || firstName.isEmpty() || lastName.isEmpty()) {
            req.setAttribute("error","all_fields_required");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp); return;
        }
        if (userDAO.emailExists(email)) {
            req.setAttribute("error","email_exists");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp); return;
        }
        if (userDAO.usernameExists(username)) {
            req.setAttribute("error","username_exists");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp); return;
        }

        String token = UUID.randomUUID().toString();
        User user = new User();
        user.setUsername(username); user.setEmail(email);
        user.setPassword(PasswordUtil.hash(password));
        user.setFirstName(firstName); user.setLastName(lastName);
        user.setBio(bio); user.setFiliere(filiere); user.setSemester(semester);
        user.setValidationToken(token);

        if (userDAO.register(user)) {
            String baseUrl = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+req.getContextPath();
            EmailUtil.sendValidationEmail(email, token, baseUrl);
            req.setAttribute("success","registration_success");
        } else {
            req.setAttribute("error","registration_failed");
        }
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }
}
