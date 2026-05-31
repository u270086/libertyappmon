package com.mfwas;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.*;

public class CSVReader {

    // Define directory paths for the z/OS and Windows environments
    private static final String ZOS_DIRECTORY_PATH = "/zWebSphere/jpconfig/dev/was/scripts/zliberty/";
    private static final String WINDOWS_DIRECTORY_PATH = "H:\\Code\\csv_files";

    // Regex pattern to match CSV filenames
    private static final String FILE_PATTERN = "WAS[DP]\\.ZLIBERTY\\.[A-Z0-9]{2}(PLEX|ZATE)\\.APPMON\\.csv";

    // Determine the directory path based on the operating system
    public String getDirectoryPath() {
        String osName = System.getProperty("os.name").toLowerCase();
        return osName.contains("win") ? WINDOWS_DIRECTORY_PATH : ZOS_DIRECTORY_PATH;
    }

    // Read all CSV files matching the pattern in the directory
    public Map<String, List<Map<String, String>>> readCSVFiles() throws IOException {
        Map<String, List<Map<String, String>>> allData = new HashMap<>();
        File directory = new File(getDirectoryPath());
        File[] files = directory.listFiles((dir, name) -> name.matches(FILE_PATTERN));

        if (files != null) {
            for (File file : files) {
                logFileMetadata(file); // 🔍 Log creation and modified times

                String fileName = file.getName();
                String plex = fileName.split("\\.")[2]; // Extract *PLEX from filename
                String key = plex.substring(0, 2);      // Use first 2 characters as key (e.g. SD, TD)

                List<Map<String, String>> data = readSingleCSV(file, plex);
                allData.put(key, data);
            }
        }
        return allData;
    }

    // Read a single CSV file and parse its contents
    private List<Map<String, String>> readSingleCSV(File file, String plex) throws IOException {
        List<Map<String, String>> data = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            String[] headers = null;

            br.readLine(); // Skip creation date line

            if ((line = br.readLine()) != null) {
                headers = line.split(",");
            }

            while ((line = br.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) continue;

                String[] values = line.split(",", -1); // Preserve trailing empty strings
                if (headers == null || values.length < headers.length) {
                    System.out.println("[CSVReader] Skipping malformed line: " + line);
                    continue;
                }

                Map<String, String> row = new HashMap<>();
                row.put("PLEX", plex); // Add PLEX value to each row
                for (int i = 0; i < headers.length; i++) {
                    row.put(headers[i].trim(), values[i]);
                }
                data.add(row);
            }
        }
        return data;
    }

    // Extract available PLEX keys from matching files
    public Set<String> getAvailablePlexKeys() {
        Set<String> keys = new TreeSet<>();
        File dir = new File(getDirectoryPath());
        File[] files = dir.listFiles((d, name) -> name.matches(FILE_PATTERN));
        if (files != null) {
            for (File file : files) {
                String plex = file.getName().split("\\.")[2];
                String key = plex.length() >= 2 ? plex.substring(0, 2) : plex;
                keys.add(key);
            }
        }
        return keys;
    }

    // Log file creation and last modified timestamps
    private void logFileMetadata(File file) {
        try {
            Path path = file.toPath();
            BasicFileAttributes attrs = Files.readAttributes(path, BasicFileAttributes.class);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            String created = sdf.format(attrs.creationTime().toMillis());
            String modified = sdf.format(attrs.lastModifiedTime().toMillis());

            System.out.println("[CSVReader] File: " + file.getName());
            System.out.println("  Created: " + created);
            System.out.println("  Last Modified: " + modified);
        } catch (IOException e) {
            System.err.println("[CSVReader] Failed to read metadata for: " + file.getName());
            e.printStackTrace();
        }
    }

        public static String readCsvAsHtmlTable(File csvFile) throws IOException {
        StringBuilder html = new StringBuilder();
        html.append("<table class=\"csv-table\">");

        try (BufferedReader br = new BufferedReader(new FileReader(csvFile))) {
            String line;
            boolean header = true;

            while ((line = br.readLine()) != null) {
                String[] cols = line.split(",", -1); // keep empty columns
                html.append("<tr>");
                for (String col : cols) {
                    if (header) {
                        html.append("<th>").append(escape(col)).append("</th>");
                    } else {
                        html.append("<td>").append(escape(col)).append("</td>");
                    }
                }
                html.append("</tr>");
                header = false;
            }
        }

        html.append("</table>");
        return html.toString();
    }

    private static String escape(String value) {
        if (value == null) return "";
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }
}