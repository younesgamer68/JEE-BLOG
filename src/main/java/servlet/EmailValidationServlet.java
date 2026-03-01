package servlet;

import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/validate")
public class EmailValidationServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String token = req.getParameter("token");

        if (token == null || token.isEmpty()) {
            req.setAttribute("validationResult", "invalid_token");
            req.getRequestDispatcher("/jsp/emailValidation.jsp").forward(req, resp);
            return;
        }

        boolean ok = userDAO.validateEmail(token);
        req.setAttribute("validationResult", ok ? "success" : "invalid_token");
        req.getRequestDispatcher("/jsp/emailValidation.jsp").forward(req, resp);
    }
}
