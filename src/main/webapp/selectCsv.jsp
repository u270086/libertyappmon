<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select Any CSV</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<p style="color:blue; font-size:20px;">DEBUG: JSP is running</p>
<h2>Select Any CSV</h2>

<form method="get" action="selectCsv">
    <label for="directory">Directory path:</label>
    <input type="text" id="directory" name="directory"
           value="<%= request.getAttribute("directory") != null ? request.getAttribute("directory") : "" %>"
           style="width: 400px;">
    <input type="submit" value="List CSV files">
</form>

<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <p style="color:red;"><%= error %></p>
<%
    }
%>

<%
    File[] csvFiles = (File[]) request.getAttribute("csvFiles");
    if (csvFiles != null && csvFiles.length > 0) {
%>
    <h3>CSV files in directory</h3>
    <form method="get" action="selectCsv">
        <input type="hidden" name="directory" value="<%= request.getAttribute("directory") %>">
        <label for="file">Choose a CSV file:</label>
        <select id="file" name="file">
            <%
                for (File f : csvFiles) {
                    String name = f.getName();
                    String selectedFile = (String) request.getAttribute("selectedFile");
                    boolean selected = selectedFile != null && selectedFile.equals(name);
            %>
                <option value="<%= name %>" <%= selected ? "selected" : "" %>><%= name %></option>
            <%
                }
            %>
        </select>
        <input type="submit" value="View CSV">
    </form>
<%
    } else if (request.getAttribute("directory") != null && error == null) {
%>
    <p>No CSV files found in this directory.</p>
<%
    }
%>

<%
    String tableHtml = (String) request.getAttribute("tableHtml");
    if (tableHtml != null) {
%>
    <h3>CSV contents: <%= request.getAttribute("selectedFile") %></h3>
    <div class="csv-table-container">
        <%= tableHtml %>
    </div>
<%
    }
%>

<p><a href="home.jsp">Back to home</a></p>
</body>
</html>