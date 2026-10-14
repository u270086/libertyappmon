package com.mfwas.api;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.json.*;
import java.io.File;
import java.io.IOException;

/**
 * CSVListApiServlet
 *
 * WHAT THIS SERVLET DOES:
 * -----------------------
 * Returns a JSON list of all CSV files located in the fixed USS directory:
 *     /zWebSphere/jpconfig/dev/was/scripts/versioninfo/
 *
 * SECURITY / AUDIT NOTES:
 * -----------------------
 * - The directory is locked to BASE_DIR; users cannot change it.
 * - Only .csv files are returned.
 * - No filesystem paths are exposed in the JSON response.
 * - Safe for consumption by UI or future React components.
 */

@WebServlet("/api/csvfiles")
public class CSVListApiServlet extends HttpServlet {

    private static final String BASE_DIR = "H:\\Documents";
    //private static final String BASE_DIR = "/zWebSphere/jpconfig/dev/was/scripts/versioninfo/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String path = req.getParameter("path");

        if (path == null || !normalize(path).equals(normalize(BASE_DIR))) {
            sendError(resp, "Access denied");
            return;
        }

        File dir = new File(path);
        if (!dir.exists() || !dir.isDirectory()) {
            sendError(resp, "Directory not found");
            return;
        }

        JsonArrayBuilder files = Json.createArrayBuilder();

        File[] list = dir.listFiles();
        if (list != null) {
            for (File f : list) {
                if (f.isFile() && f.getName().toLowerCase().endsWith(".csv")) {
                    files.add(f.getName());
                }
            }
        }

        JsonObject json = Json.createObjectBuilder()
                .add("files", files)
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