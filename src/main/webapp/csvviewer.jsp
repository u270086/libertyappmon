<%@ page import="java.io.*, com.mfwas.CSVReader" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>CSV Viewer</title>
   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>

<body>

<h2>CSV Viewer</h2>

<%
    String path = request.getParameter("path");
    String file = request.getParameter("file");

    if (path == null || file == null) {
%>
        <p>No file selected</p>
<%
    } else {
        File csv = new File(path, file);

        if (!csv.exists()) {
%>
            <p>File not found: <%= csv.getAbsolutePath() %></p>
<%
        } else {
            String html = CSVReader.readCsvAsHtmlTable(csv);
            out.print(html);
        }
    }
%>

</body>
</html>