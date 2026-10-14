package com.mfwas.api;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.json.*;
import java.io.*;

/**
 * CSVContentApiServlet
 *
 * WHAT THIS SERVLET DOES:
 * -----------------------
 * Returns the content of a selected CSV file as JSON.
 * The CSV file must:
 *   - be located inside the fixed USS directory
 *   - be a .csv file
 *   - be present in the directory allow-list
 *
 * SECURITY / AUDIT NOTES:
 * -----------------------
 * - Directory is locked to BASE_DIR.
 * - Filename validation so you cant choose any old file
 * - Only .csv files are permitted.
 * - Only files actually present in the directory are allowed.
 * - JSON output as requested by Avnindra.
 */

@WebServlet("/api/csvfile")
public class CSVContentApiServlet extends HttpServlet {

    private static final String BASE_DIR = "H:\\Documents";
    //private static final String BASE_DIR = "/zWebSphere/jpconfig/dev/was/scripts/versioninfo/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String path = req.getParameter("path");
        String file = req.getParameter("file");

        if (path == null || file == null ||
            path.isEmpty() || file.isEmpty()) {
            sendError(resp, "Missing parameters");
            return;
        }

        if (!normalize(path).equals(normalize(BASE_DIR))) {
            sendError(resp, "Access denied");
            return;
        }

        if (file.contains("/") || file.contains("\\") || file.contains("..")) {
            sendError(resp, "Invalid filename");
            return;
        }

        if (!file.toLowerCase().endsWith(".csv")) {
            sendError(resp, "Only CSV files are permitted");
            return;
        }

        File dir = new File(path);
        String[] allowed = dir.list((d, name) -> name.toLowerCase().endsWith(".csv"));

        boolean allowedFile = false;
        if (allowed != null) {
            for (String f : allowed) {
                if (f.equalsIgnoreCase(file)) {
                    allowedFile = true;
                    break;
                }
            }
        }

        if (!allowedFile) {
            sendError(resp, "File is not permitted");
            return;
        }

        File csv = new File(path, file);
        if (!csv.exists() || !csv.isFile()) {
            sendError(resp, "File not found");
            return;
        }

        JsonArrayBuilder rows = Json.createArrayBuilder();

        try (BufferedReader br = new BufferedReader(new FileReader(csv))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] cols = line.split(",", -1);
                JsonArrayBuilder row = Json.createArrayBuilder();
                for (String col : cols) {
                    row.add(col.trim());
                }
                rows.add(row);
            }
        }

        JsonObject json = Json.createObjectBuilder()
                .add("rows", rows)
                .build();

        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }

    private void sendError(HttpServletResponse resp, String msg) throws IOException {
        JsonObject json = Json.createObjectBuilder()
                .add("error", msg)
                .build();
        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }

    private String normalize(String p) {
        return p.replace('\\', '/');
    }
}