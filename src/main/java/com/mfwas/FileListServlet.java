package com.mfwas;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.json.*;
import java.io.*;

@WebServlet("/api/files")
public class FileListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String dir = req.getParameter("dir");

        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

        if (dir != null) {
            File folder = new File(dir);

            if (folder.exists() && folder.isDirectory()) {

                File[] csvFiles = folder.listFiles(
                        f -> f.getName().toLowerCase().endsWith(".csv")
                );

                if (csvFiles != null) {
                    for (File f : csvFiles) {
                        arrayBuilder.add(f.getName());
                    }
                }
            }
        }

        JsonObject json = Json.createObjectBuilder()
                .add("files", arrayBuilder)
                .build();

        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }
}
