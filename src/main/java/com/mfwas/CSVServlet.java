package com.mfwas;

import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/csv")
public class CSVServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String plex = request.getParameter("plex");

        CSVReader csvReader = new CSVReader();
        Map<String, List<Map<String, String>>> allCsvData = csvReader.readCSVFiles();
        List<Map<String, String>> csvData = new ArrayList<>();
        String creationDate = null;

        if (plex != null && !plex.isEmpty() && allCsvData.containsKey(plex)) {
            csvData = allCsvData.get(plex);

            File dir = new File(csvReader.getDirectoryPath());
            File[] files = dir.listFiles((d, name) -> name.matches("WAS[DP]\\.ZLIBERTY\\.[A-Z0-9]{2}(PLEX|ZATE)\\.APPMON\\.csv") && name.contains(plex));
            if (files != null && files.length > 0) {
                creationDate = getFileCreationDate(files[0]);
            }
        } else {
            for (List<Map<String, String>> data : allCsvData.values()) {
                csvData.addAll(data);
            }
        }

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String plexLabel = (plex == null || plex.isEmpty()) ? "ALL" : plex;
        String htmlResponse = generateHtmlTable(csvData, creationDate, plexLabel);

        response.getWriter().write(htmlResponse);
    }

    private String generateHtmlTable(List<Map<String, String>> data, String creationDate, String plexLabel) {
        StringBuilder htmlBuilder = new StringBuilder();

        htmlBuilder.append("<!DOCTYPE html>");
        htmlBuilder.append("<html><head>");
        htmlBuilder.append("<meta charset='UTF-8'>");
        htmlBuilder.append("<title>PLEX - ").append(plexLabel).append("</title>");
        htmlBuilder.append("<link rel='stylesheet' type='text/css' href='css/style.css'>");
        htmlBuilder.append("<script src='js/dropdown.js' defer></script>");
        htmlBuilder.append("</head><body>");
        htmlBuilder.append("<h2>Liberty Configuration PLEX: ").append(plexLabel).append("</h2>");

        if (creationDate != null) {
            htmlBuilder.append("<p><em>Created on: ").append(creationDate).append("</em></p>");
        }

        // ✅ Show Download Button only for ALL PLEXES
        if ("ALL".equalsIgnoreCase(plexLabel)) {
            htmlBuilder.append("<form method='get' action='DownloadServlet'>");
            htmlBuilder.append("<input type='hidden' name='plex' value='ALL'/>");
            htmlBuilder.append("<button type='submit' class='download-btn'>Download CSV</button>");
            htmlBuilder.append("</form>");
        }

        htmlBuilder.append("<table>");

        if (!data.isEmpty()) {
            htmlBuilder.append("<tr>");
            for (String header : data.get(0).keySet()) {
                htmlBuilder.append("<th>").append(header).append("</th>");
            }
            htmlBuilder.append("</tr>");

            for (Map<String, String> row : data) {
                htmlBuilder.append("<tr>");
                for (String value : row.values()) {
                    htmlBuilder.append("<td>").append(value).append("</td>");
                }
                htmlBuilder.append("</tr>");
            }
        }

        htmlBuilder.append("</table>");
        htmlBuilder.append("</body></html>");

        return htmlBuilder.toString();
    }

    private String getFileCreationDate(File file) {
        try {
            Path path = file.toPath();
            BasicFileAttributes attrs = Files.readAttributes(path, BasicFileAttributes.class);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.format(attrs.creationTime().toMillis());
        } catch (IOException e) {
            System.err.println("[CSVServlet] Failed to get creation date for: " + file.getName());
            return null;
        }
    }
}