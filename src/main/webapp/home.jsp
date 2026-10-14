<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liberty App Monitor – Home</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/ui/bootstrap/bootstrap.min.css">

    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ⭐ Wizard of WAS Hero Banner -->
<div class="hero-banner">
    <img src="images/WIZARD_WILL_OFF_WAS.png"
         alt="Wizard of WAS"
         class="hero-image">
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

    <a href="react/index.html" class="glass-tile">
        <div class="tile-icon">⚛️</div>
        <div class="tile-title">React Dashboard</div>
        <div class="tile-desc">Modern UI for API endpoints</div>
    </a>

    <a href="#" class="glass-tile disabled">
        <div class="tile-icon">🛠️</div>
        <div class="tile-title">WAS System Symbols (Coming Soon)</div>
        <div class="tile-desc">Another Great New Thing Appearing Soon!</div>
    </a>

</div>

<!--<button class="btn btn-primary">Bootstrap Test</button> -->

<!-- Bootstrap JS bundle -->
    <script src="<%= request.getContextPath() %>/ui/bootstrap/bootstrap.bundle.min.js"></script>

</body>
</html>