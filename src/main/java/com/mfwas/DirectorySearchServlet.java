package com.mfwas;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import javax.json.*;
import java.io.*;

@WebServlet("/api/directories")
public class DirectorySearchServlet extends HttpServlet {

    // You can change this to whatever root you want users to browse
    private static final String BASE_PATH = "H:/";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        File base = new File(BASE_PATH);

        JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();

        File[] dirs = base.listFiles(File::isDirectory);
        if (dirs != null) {
            for (File d : dirs) {
                arrayBuilder.add(d.getAbsolutePath());
            }
        }

        JsonObject json = Json.createObjectBuilder()
                .add("directories", arrayBuilder)
                .build();

        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }
}