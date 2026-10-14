<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // --- Christmas Window Logic ---
    java.time.LocalDate today = java.time.LocalDate.now();
    java.time.LocalDate christmas = java.time.LocalDate.of(today.getYear(), 12, 25);

    java.time.LocalDate start = christmas.minusDays(7);
    java.time.LocalDate end = christmas.plusDays(7);

    boolean inChristmasWindow = !today.isBefore(start) && !today.isAfter(end);

    // --- Manual override for testing ---
    // Set to true to force Christmas mode even outside the date window
    boolean testChristmasMode = false;

    boolean showChristmasLogo = inChristmasWindow || testChristmasMode;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Liberty App Monitor – Home</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ⭐ Seasonal Banner -->
<div class="hero-banner">
    <% if (showChristmasLogo) { %>
        <img src="images/WAS_LIBERTY_CHRISTMAS_2026.png"
             alt="Christmas Liberty Logo"
             class="hero-image">
    <% } else { %>
        <img src="images/WIZARD_WILL_OFF_WAS.png"
             alt="Wizard of WAS"
             class="hero-image">
    <% } %>
</div>

<h2 class="home-title">Liberty App Monitor</h2>

<div class="tile-container">

    <a href="index" class="glass-tile">
        <div class="tile-icon">📊</div>
        <div class="tile-title">PLEX CSV Viewer</div>
        <div class="tile-desc">Select PLEX & View Liberty CSV data</div>
    </a>

    <a href="directory/index.jsp" class="glass-tile">
        <div class="tile-icon">📂</div>
        <div class="tile-title">Select CSV</div>
        <div class="tile-desc">Browse Directories and Preview CSV Files</div>
    </a>

    <a href="react/index.html" class="glass-tile disabled">
        <div class="tile-icon">⚛️</div>
        <div class="tile-title">React Dashboard (Coming soon)</div>
        <div class="tile-desc">Modern UI for API endpoints</div>
    </a>

    <a href="#" class="glass-tile disabled">
        <div class="tile-icon">🛠️</div>
        <div class="tile-title">WAS System Symbols (Coming Soon)</div>
        <div class="tile-desc">Another Great New Thing Appearing Soon!</div>
    </a>

</div>

</body>
</html>