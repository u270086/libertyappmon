<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Month" %>
<!DOCTYPE html>
<html>
<head>
    <title>Select PLEX</title>
    <link rel="stylesheet" type="text/css" href="css/style.css?v=<%= System.currentTimeMillis() %>">
    <link rel="icon" type="image/png" sizes="32x32" href="mfwas-32x32.png">
    <!-- Removed dropdown.js reference since it's no longer needed -->
</head>
<body>

<%
    //-- 💓 Logo selection with pulse animation section --
    String logoFile = "WAS_LOGO.png"; //Set the default logo

    //LocalDate today = LocalDate.now();
    LocalDate today = LocalDate.of(2025, Month.DECEMBER, 10); // Simulate Christmas period
    //LocalDate today = LocalDate.of(2025, Month.OCTOBER, 20); // Simulate Halloween period

    LocalDate halloweenStart = LocalDate.of(today.getYear(), Month.OCTOBER, 15); // Set start date of 15th OCTOBER
    LocalDate halloweenEnd = LocalDate.of(today.getYear(), Month.OCTOBER, 31); // Set end date of 15th OCTOBER

    //check if we are in the Halloween period 15th - 31st OCTOBER
    boolean isHalloweenPeriod = !today.isBefore(halloweenStart) && !today.isAfter(halloweenEnd);
    boolean isChristmas = today.getMonth() == Month.DECEMBER;

    if (isHalloweenPeriod) {
        logoFile = "WAS_HALLOWEEN_LOGO.png";
    }

    if (isChristmas) {
        logoFile = "WAS_XMAS_LOGO.png";
    }
%>
    <!-- 💓 Display relevant WAS TEAM Logo with pulse animation section -->    
    <div class="logo-container">
        <img src="<%= logoFile %>" alt="Mainframe WAS Logo">
    </div>

<%
    // --- HALLOWEEN DISCLAIMER LOGIC --- 
    // If in the Halloween period display a special disclaimer message
    if (isHalloweenPeriod) {
%>
<div class="halloween-disclaimer">
Disclaimer: This Webpage In No Way Infers The WAS Teams Belief In The Supernatural Or The Occult.<br>
Any Suggestion Otherwise Will Be Met With A Stern Look And A Mild Hex From The Wizard of WAS.
</div>
<% } %>

<%
    // --- CHRISTMAS MESSAGE LOGIC --- 
    // If its December display a seasonal message
if (isChristmas) {
%>
  <div class="christmas-greeting">
    ❄️ Season's greetings from the WAS team ❄️ <br>
    May your deployments be smooth and your dashboards sparkle!
  </div>
<% } %>

    <h2>Select a PLEX to View CSV Data</h2>

    <form id="plexForm" action="csv" method="get">
        <label for="plex">PLEX:</label>
        <select name="plex" id="plex" onchange="document.getElementById('plexForm').submit();">
            <option value="" disabled selected>Select a PLEX</option>
            <option value="ALL">All PLEX</option>
            <%
                Set<String> plexKeys = (Set<String>) request.getAttribute("plexKeys");
                if (plexKeys != null && !plexKeys.isEmpty()) {
                    for (String key : plexKeys) {
            %>
                        <option value="<%= key %>"><%= key %></option>
            <%
                    }
                } else {
            %>
                <option disabled>No CSV files found</option>
            <%
                }
            %>
        </select>
    </form>

    <!-- Removed Download CSV button -->

<script>
  window.addEventListener('pageshow', function (event) {
    if (event.persisted) {
      window.location.reload();
    }
  });
</script>

</body>
</html>