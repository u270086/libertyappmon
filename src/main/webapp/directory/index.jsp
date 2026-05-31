<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Directory Explorer</title>

    <!-- Global styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=<%= System.currentTimeMillis() %>">

    <!-- Directory Explorer styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/directory.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>

<div class="directory-container">
    <h2>Directory Explorer</h2>

    <!-- Directory dropdown -->
    <label>Select a directory:</label>
    <select id="directorySelect">
        <option value="">Loading directories...</option>
    </select>

    <!-- CSV dropdown -->
    <label style="margin-top:20px;">Select a CSV file:</label>
    <select id="csvSelect" disabled>
        <option value="">Select a directory first</option>
    </select>

    <!-- Preview area -->
    <div id="preview">
        <em>No CSV selected</em>
    </div>
</div>

<script>
    const base = "<%= request.getContextPath() %>";

    window.onload = function () {
        loadDirectories();
    };

    function loadDirectories() {
        fetch(base + "/api/directories")
            .then(response => response.json())
            .then(data => {
                const select = document.getElementById("directorySelect");
                select.innerHTML = "";

                data.directories.forEach(dir => {
                    const opt = document.createElement("option");
                    opt.value = dir;
                    opt.textContent = dir;
                    select.appendChild(opt);
                });

                select.disabled = false;
            })
            .catch(err => {
                console.error(err);
                alert("Failed to load directories");
            });
    }

    document.getElementById("directorySelect").addEventListener("change", function () {
        const dir = this.value;
        const csvSelect = document.getElementById("csvSelect");

        if (!dir) {
            csvSelect.disabled = true;
            csvSelect.innerHTML = "<option>Select a directory first</option>";
            return;
        }

        csvSelect.innerHTML = "<option>Loading...</option>";

        fetch(base + "/api/files?dir=" + encodeURIComponent(dir))
            .then(response => response.json())
            .then(data => {
                csvSelect.innerHTML = "";
                data.files.forEach(file => {
                    const opt = document.createElement("option");
                    opt.value = file;
                    opt.textContent = file;
                    csvSelect.appendChild(opt);
                });

                csvSelect.disabled = false;
            })
            .catch(err => {
                console.error(err);
                alert("Failed to load CSV files");
            });
    });

    document.getElementById("csvSelect").addEventListener("change", function () {
        const file = this.value;
        const dir = document.getElementById("directorySelect").value;

        if (!file) return;

        const preview = document.getElementById("preview");
        preview.innerHTML = "<p class='loading'>Loading preview...</p>";

        fetch(base + "/csvPreview?dir=" + encodeURIComponent(dir) + "&file=" + encodeURIComponent(file))
            .then(response => response.text())
            .then(html => {
                preview.innerHTML = html;
            })
            .catch(err => {
                console.error(err);
                preview.innerHTML = "<p>Error loading CSV preview</p>";
            });
    });
</script>

</body>
</html>