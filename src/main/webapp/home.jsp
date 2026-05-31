<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liberty App Monitor – Home</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ⭐ New WAS Logo Section -->
<div class="newWAS-logo-container">
    <img src="was-great-and-powerful.png" alt="WAS The Great and Powerful" class="newWAS-logo">
</div>

<h2>Liberty App Monitor</h2>

<div class="tile-container">

    <a href="index" class="glass-tile">
        <div class="tile-icon">📊</div>
        <div class="tile-title">PLEX CSV Viewer</div>
        <div class="tile-desc">Select PLEX & View Liberty CSV data</div>
    </a>

    <a href="selectCsv" class="glass-tile">
        <div class="tile-icon">📁</div>
        <div class="tile-title">Select Any CSV</div>
        <div class="tile-desc">Browse any directory and open CSV files</div>
    </a>

    <!-- ⭐ New React Landing Page Tile (future feature) -->
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