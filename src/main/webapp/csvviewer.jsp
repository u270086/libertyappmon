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
    String error = (String) request.getAttribute("error");
    String html  = (String) request.getAttribute("tableHtml");
    String file  = (String) request.getAttribute("fileName");
%>

<% if (error != null) { %>

    <p style="color:#b00020;"><%= error %></p>

<% } else if (html != null) { %>

    <div class="csv-header">
        <strong>Viewing:</strong> <%= file %>
    </div>

    <div class="csv-content">
        <%= html %>
    </div>

<% } else { %>

    <p>No CSV selected.</p>

<% } %>

</body>
</html>