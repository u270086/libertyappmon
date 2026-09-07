import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

import java.io.IOException;
import java.io.File;

import javax.json.Json;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;

@WebServlet("/api/directories")
public class DirectorySearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String path = req.getParameter("path");

        File dir;

        if (path == null || path.isBlank()) {
            File[] roots = File.listRoots();
            dir = (roots != null && roots.length > 0) ? roots[0] : new File("/");
        } else {
            dir = new File(path).getCanonicalFile();
        }

        JsonArrayBuilder dirs = Json.createArrayBuilder();

        if (dir.exists() && dir.isDirectory()) {
            File[] subdirs = dir.listFiles(File::isDirectory);
            if (subdirs != null) {
                for (File d : subdirs) {
                    dirs.add(d.getName());
                }
            }
        }

        JsonObject json = Json.createObjectBuilder()
                .add("currentPath", dir.getAbsolutePath())   // ⭐ REQUIRED
                .add("directories", dirs)                    // ⭐ REQUIRED
                .build();

        resp.setContentType("application/json");
        resp.getWriter().write(json.toString());
    }
}