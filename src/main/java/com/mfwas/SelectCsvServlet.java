package com.mfwas;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;

@WebServlet("/selectCsv")
public class SelectCsvServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String directoryPath = request.getParameter("directory");
        String fileName = request.getParameter("file");

        if (directoryPath != null && !directoryPath.isBlank()) {
            File dir = new File(directoryPath);

            if (dir.exists() && dir.isDirectory()) {
                File[] csvFiles = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".csv"));
                request.setAttribute("directory", directoryPath);
                request.setAttribute("csvFiles", csvFiles);

                if (fileName != null && !fileName.isBlank()) {
                    File selected = new File(dir, fileName);
                    if (selected.exists() && selected.isFile()) {
                        String tableHtml = CSVReader.readCsvAsHtmlTable(selected);
                        request.setAttribute("selectedFile", fileName);
                        request.setAttribute("tableHtml", tableHtml);
                    } else {
                        request.setAttribute("error", "Selected file does not exist.");
                    }
                }
            } else {
                request.setAttribute("error", "Directory does not exist or is not a directory.");
            }
        }

        request.getRequestDispatcher("/selectCsv.jsp").forward(request, response);
    }
}
