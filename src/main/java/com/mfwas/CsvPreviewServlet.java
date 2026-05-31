package com.mfwas;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.*;

@WebServlet("/csvPreview")
public class CsvPreviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String dir = req.getParameter("dir");
        String file = req.getParameter("file");

        if (dir == null || file == null) {
            resp.getWriter().write("<p>No file selected</p>");
            return;
        }

        File csv = new File(dir, file);

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

