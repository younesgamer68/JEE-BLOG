package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/language")
public class LanguageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String lang  = req.getParameter("lang");
        String referer = req.getHeader("Referer");

        if (lang != null && (lang.equals("fr") || lang.equals("en"))) {
            HttpSession session = req.getSession(true);
            session.setAttribute("lang", lang);
        }

        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/articles");
        }
    }
}
