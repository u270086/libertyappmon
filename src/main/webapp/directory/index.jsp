<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Directory Explorer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/directory.css">
</head>

<body>

<div class="directory-container">
    <h2>Directory Explorer</h2>

    <div class="path-bar">
        <input type="text" id="pathInput" placeholder="Enter path (e.g. C:\ or /u/jason)">
        <button id="goButton">Go</button>
    </div>

    <div id="breadcrumbs" class="breadcrumbs"></div>

    <div class="main-layout">

        <div class="left-pane">
            <div class="pane-header">Directories & CSV files</div>
            <div id="dirList" class="list-panel"></div>
        </div>

        <div class="right-pane">
            <div class="pane-header">CSV Preview</div>
            <div id="preview" class="preview-panel">
                <em>No CSV selected</em>
            </div>
        </div>
    </div>
</div>

<script>
    const base = "<%= request.getContextPath() %>";

    window.onload = function () {
        loadDirectory(null);
        document.getElementById("goButton").onclick = onGo;
    };

    function onGo() {
        const path = document.getElementById("pathInput").value.trim();
        loadDirectory(path || null);
    }

    function loadDirectory(path) {
        const url = base + "/api/directories" + (path ? "?path=" + encodeURIComponent(path) : "");

        fetch(url)
            .then(r => r.json())
            .then(data => {
                document.getElementById("pathInput").value = data.currentPath;
                renderBreadcrumbs(data.currentPath);
                renderDirectoryList(data.currentPath, data.directories);
                loadCsvFiles(data.currentPath);
            });
    }

    function renderBreadcrumbs(path) {
        const bc = document.getElementById("breadcrumbs");
        bc.innerHTML = path;
    }

    function renderDirectoryList(currentPath, directories) {
        const container = document.getElementById("dirList");
        container.innerHTML = "";

        const list = document.createElement("ul");

        const up = document.createElement("li");
        up.textContent = "⬆ ..";
        up.onclick = () => goUp(currentPath);
        list.appendChild(up);

        directories.forEach(name => {
            const li = document.createElement("li");
            li.textContent = "📂 " + name;
            li.onclick = () => loadDirectory(joinPath(currentPath, name));
            list.appendChild(li);
        });

        container.appendChild(list);
    }

    function goUp(path) {
        const idx = path.lastIndexOf("\\");
        const parent = idx <= 2 ? path.substring(0, 3) : path.substring(0, idx);
        loadDirectory(parent);
    }

    function joinPath(base, name) {
        return base.endsWith("\\") ? base + name : base + "\\" + name;
    }

    function loadCsvFiles(path) {
        const url = base + "/api/files?path=" + encodeURIComponent(path);

        fetch(url)
            .then(r => r.json())
            .then(data => {
                const container = document.getElementById("dirList");
                const list = container.querySelector("ul");

                data.files.forEach(name => {
                    const li = document.createElement("li");
                    li.textContent = "📄 " + name;

                    li.onclick = () => {
                        window.location.href = base + "/csvviewer.jsp?path="
                            + encodeURIComponent(path)
                            + "&file="
                            + encodeURIComponent(name);
                    };

                    list.appendChild(li);
                });
            });
    }

    function loadCsvPreview(path, file) {
        const preview = document.getElementById("preview");
        preview.innerHTML = "<p>Loading...</p>";

        const url = base + "/csvPreview?path=" + encodeURIComponent(path) + "&file=" + encodeURIComponent(file);

        fetch(url)
            .then(r => r.text())
            .then(html => preview.innerHTML = html);
    }
</script>

</body>
</html>