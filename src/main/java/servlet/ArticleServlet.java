package servlet;

import dao.ArticleDAO;
import dao.CommentDAO;
import model.Article;
import model.Comment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/articles")
public class ArticleServlet extends HttpServlet {

    private final ArticleDAO articleDAO = new ArticleDAO();
    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "list":    listArticles(req, resp); break;
            case "detail":  showDetail(req, resp);   break;
            case "add":     showAddForm(req, resp);  break;
            case "edit":    showEditForm(req, resp);  break;
            case "delete":  deleteArticle(req, resp); break;
            default:        listArticles(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("update".equals(action)) updateArticle(req, resp);
        else createArticle(req, resp);
    }

    private void listArticles(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1;
        try { page = Math.max(1, Integer.parseInt(req.getParameter("page"))); } catch (Exception ignored) {}
        int totalPages = articleDAO.getTotalPages();
        int totalCount = articleDAO.countAll();
        if (page > totalPages && totalPages > 0) page = totalPages;
        List<Article> articles = articleDAO.findPage(page);
        req.setAttribute("articles",   articles);
        req.setAttribute("currentPage",page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.getRequestDispatcher("/jsp/articles.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        req.setAttribute("article",  articleDAO.findById(id));
        req.setAttribute("comments", commentDAO.findByArticle(id));
        req.getRequestDispatcher("/jsp/articleDetail.jsp").forward(req, resp);
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (requireLogin(req, resp) == null) return;
        req.getRequestDispatcher("/jsp/addArticle.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;
        int id = Integer.parseInt(req.getParameter("id"));
        Article article = articleDAO.findById(id);
        if (article == null || article.getAuthorId() != user.getId()) {
            resp.sendRedirect(req.getContextPath() + "/articles"); return;
        }
        req.setAttribute("article", article);
        req.getRequestDispatcher("/jsp/addArticle.jsp").forward(req, resp);
    }

    private void createArticle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;
        String title   = req.getParameter("title").trim();
        String content = req.getParameter("content").trim();
        if (title.isEmpty() || content.isEmpty()) {
            req.setAttribute("error","fields_required");
            req.getRequestDispatcher("/jsp/addArticle.jsp").forward(req, resp); return;
        }
        Article a = new Article();
        a.setAuthorId(user.getId()); a.setTitle(title); a.setContent(content);
        articleDAO.create(a);
        resp.sendRedirect(req.getContextPath() + "/articles");
    }

    private void updateArticle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;
        Article a = new Article();
        a.setId(Integer.parseInt(req.getParameter("id")));
        a.setAuthorId(user.getId());
        a.setTitle(req.getParameter("title").trim());
        a.setContent(req.getParameter("content").trim());
        articleDAO.update(a);
        resp.sendRedirect(req.getContextPath() + "/articles?action=detail&id=" + a.getId());
    }

    private void deleteArticle(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;
        articleDAO.delete(Integer.parseInt(req.getParameter("id")), user.getId());
        resp.sendRedirect(req.getContextPath() + "/articles");
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return null;
        }
        return (User) session.getAttribute("currentUser");
    }
}
