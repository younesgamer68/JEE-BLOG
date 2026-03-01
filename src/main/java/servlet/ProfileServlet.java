package servlet;

import dao.ArticleDAO;
import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserDAO    userDAO    = new UserDAO();
    private final ArticleDAO articleDAO = new ArticleDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;
        req.setAttribute("user",       user);
        req.setAttribute("myArticles", articleDAO.findByAuthor(user.getId()));
        req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = requireLogin(req, resp);
        if (user == null) return;

        user.setFirstName(req.getParameter("firstName").trim());
        user.setLastName(req.getParameter("lastName").trim());
        user.setBio(req.getParameter("bio") != null ? req.getParameter("bio").trim() : "");
        user.setFiliere(req.getParameter("filiere") != null ? req.getParameter("filiere").trim() : "");
        int sem = 0;
        try { sem = Integer.parseInt(req.getParameter("semester")); } catch (Exception ignored) {}
        user.setSemester(sem);

        if (userDAO.updateProfile(user)) {
            req.getSession(false).setAttribute("currentUser", userDAO.findById(user.getId()));
            req.setAttribute("success","profile_updated");
        } else {
            req.setAttribute("error","update_failed");
        }
        req.setAttribute("user",       userDAO.findById(user.getId()));
        req.setAttribute("myArticles", articleDAO.findByAuthor(user.getId()));
        req.getRequestDispatcher("/jsp/profile.jsp").forward(req, resp);
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return null;
        }
        return (User) session.getAttribute("currentUser");
    }
}
