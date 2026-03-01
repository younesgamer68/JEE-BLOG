package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/settings")
public class SettingsServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);
        String translateEnabled = req.getParameter("translateEnabled");
        session.setAttribute("translateEnabled", "true".equals(translateEnabled));

        String referer = req.getHeader("Referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/articles");
    }
}
