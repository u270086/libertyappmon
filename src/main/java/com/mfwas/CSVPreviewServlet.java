package com.mfwas;

//import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/csvPreview")
public class CSVPreviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        // ⭐ FIX: match the Directory Explorer JSP
        String path = req.getParameter("path");
        String file = req.getParameter("file");

        if (path == null || file == null) {
            resp.getWriter().write("<p>No file selected</p>");
            return;
        }

        File csv = new File(path, file);

        if (!csv.exists()) {
            resp.getWriter().write("<p>File not found</p>");
            return;
        }

        // Reuse your existing CSVReader logic
        String html = CSVReader.readCsvAsHtmlTable(csv);

        resp.setContentType("text/html");
        resp.getWriter().write(html);
    }
}