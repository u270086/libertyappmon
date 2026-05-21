package com.mfwas;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet("/DownloadServlet")
public class DownloadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String plex = request.getParameter("plex");

        // Only allow download for ALL PLEXES
        if ("ALL".equalsIgnoreCase(plex)) {
            CSVReader csvReader = new CSVReader();
            Map<String, List<Map<String, String>>> allCsvData = csvReader.readCSVFiles();

            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=\"all_plexes.csv\"");

            PrintWriter writer = response.getWriter();

            // Write CSV headers
            boolean headerWritten = false;
            for (List<Map<String, String>> plexData : allCsvData.values()) {
                for (Map<String, String> row : plexData) {
                    if (!headerWritten) {
                        writer.println(String.join(",", row.keySet()));
                        headerWritten = true;
                    }
                    writer.println(String.join(",", row.values()));
                }
            }

            writer.close();
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid PLEX selection for download.");
        }
    }
}