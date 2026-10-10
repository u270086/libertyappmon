package com.mfwas;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet("/csvviewer")
public class CSVViewerServlet extends HttpServlet {

    // Optional: restrict access to a known base directory (USS or Windows)
    private static final String BASE_DIR = null; // e.g. "/u/jason" if you want USS restriction

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getParameter("path");
        String file = request.getParameter("file");

        // Basic parameter validation
        if (path == null || path.isEmpty() || file == null || file.isEmpty()) {
            request.setAttribute("error", "No CSV file selected.");
            forward(request, response);
            return;
        }

        // Filename validation — no traversal, no separators
        if (file.contains("/") || file.contains("\\") || file.contains("..")) {
            request.setAttribute("error", "Invalid file name.");
            forward(request, response);
            return;
        }

        // Optional: restrict path to a safe base directory
        if (BASE_DIR != null && !normalize(path).startsWith(normalize(BASE_DIR))) {
            request.setAttribute("error", "Access to this path is not permitted.");
            forward(request, response);
            return;
        }

        File csv = new File(path, file);

        if (!csv.exists() || !csv.isFile()) {
            request.setAttribute("error", "CSV file not found.");
            forward(request, response);
            return;
        }

        try {
            // Your existing CSVReader must return safe HTML
            String html = CSVReader.readCsvAsHtmlTable(csv);
            request.setAttribute("tableHtml", html);
            request.setAttribute("fileName", file);
        } catch (Exception e) {
            request.setAttribute("error", "Error reading CSV file.");
        }

        forward(request, response);
    }

    private void forward(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/csvviewer.jsp").forward(request, response);
    }

    private String normalize(String p) {
        return p == null ? "" : p.replace('\\', '/');
    }
}