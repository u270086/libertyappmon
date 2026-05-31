package com.mfwas;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;

@WebServlet("/index")
public class IndexServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Handle GET requests to /index
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("today", LocalDate.now());

        // Use CSVReader to get available PLEX keys
        CSVReader reader = new CSVReader();
        Set<String> plexKeys = reader.getAvailablePlexKeys();

        // Pass the keys to index.jsp
        request.setAttribute("plexKeys", plexKeys);

        // Forward to JSP for rendering
        RequestDispatcher dispatcher = request.getRequestDispatcher("/index.jsp");
        dispatcher.forward(request, response);
    }
}
