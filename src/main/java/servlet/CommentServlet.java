package servlet;

import dao.CommentDAO;
import model.Comment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/comments")
public class CommentServlet extends HttpServlet {

    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user    = (User) session.getAttribute("currentUser");
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            int commentId = Integer.parseInt(req.getParameter("commentId"));
            int articleId = Integer.parseInt(req.getParameter("articleId"));
            commentDAO.delete(commentId, user.getId());
            resp.sendRedirect(req.getContextPath() + "/articles?action=detail&id=" + articleId);
            return;
        }

        // Default: add comment
        int    articleId = Integer.parseInt(req.getParameter("articleId"));
        String content   = req.getParameter("content").trim();

        if (!content.isEmpty()) {
            Comment comment = new Comment();
            comment.setArticleId(articleId);
            comment.setAuthorId(user.getId());
            comment.setContent(content);
            commentDAO.create(comment);
        }

        resp.sendRedirect(req.getContextPath() + "/articles?action=detail&id=" + articleId);
    }
}
