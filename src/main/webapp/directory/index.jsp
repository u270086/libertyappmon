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
        <label for="pathInput">Path:</label>
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

    let lastLoadedPath = null;
    let requestSeq = 0;

    window.addEventListener("load", () => {
        document.getElementById("goButton").addEventListener("click", onGo);
        loadDirectory(null);    
    }); 

    function onGo() {
        const path = document.getElementById("pathInput").value.trim();
        loadDirectory(path || null);
    }

    async function loadDirectory(path) {
        const mySeq = ++requestSeq;

        // Basic loading UI
        setPreviewMessage("No CSV Selected");
        renderDirectoryLoading();

        const url = base + "/api/directories" + (path ? "?path=" + encodeURIComponent(path) : "");

        try {
            const r = await fetch(url);
            if (!r.ok) throw new Error("Failed to load directory (HTTP ${r.status});");
            const data = await r.json();

            // Ignore out-of-order responses
            if (mySeq !== requestSeq) return;

            lastLoadedPath = data.currentPath;

            const pathInput = document.getElementById("pathInput");
            pathInput.value = data.currentPath || "";

            renderBreadcrumbs(data.currentPath || "");
            renderDirectoryList(data.currentPath || "", data.directories || []);
            await loadCsvFiles(data.currentPath || "", mySeq);

        } catch (err) {
            if (mySeq !== requestSeq) return; // Ignore out-of-order responses
            renderDirectoryError(err.message);         
        }
    }

    function renderDirectoryLoading() {
        const container = document.getElementById("dirList");
        container.innerHTML = "";
        const div = document.createElement("div");
        div.textContent = "Loading...";
        container.appendChild(div);
    }

    function renderDirectoryError(err) {
        const container = document.getElementById("dirList");
        container.innerHTML = "";

        const msg = document.createElement("div");
        msg.style.color = "#b00020";
        msg.textContent = (err && err.message) ? err.message : "Error: loading Directory.";
        container.appendChild(msg);
    }

    function setPreviewMessage(text) {
        const preview = document.getElementById("preview");
        preview.textContent = "";
        const em = document.createElement("em");
        em.textContent = text;
        preview.appendChild(em);
    }

    //Determine separator based on the current path; z/OS USS paths are unix-style (/)
    function detectSep(path) {
        //UNC and Windows paths typically contain backslashes.
        //If both appear, prefer backslash (Windows) unless it clearly starts with "/" (Unix).
        if (path && path.startsWith("/")) return "/";
        if (path && path.includes("\\")) return "\\";
        return "/"; //default to Unix-like
    }

    function normalizePath(path, sep) {
        if (!path) return path;

        //Keep root forms intact
        if (sep === "/") {
            if (path === "/") return "/";
            //remove trailing slashes (but NOT root)
            return path.replace(/\/+$/, "");
        } else {
            //Windows
            //Drive root: C:\ or "C:"
            const driveRoot = /^[a-zA-Z]:\\?$/;
            if (driveRoot.test(path)) return path.endsWith("\\") ? path : (path + "\\");
            //UNC root-sh: "\\server\share" or "\\server\share\"
            if (path.startsWith("\\\\")) {
                return path.replace(/\\+$/, ""); //remove trailing backslashes
            }
            return path.replace(/\\+$/, ""); //remove trailing backslashes
        }
    }

    function goUp(path) {
        const sep = detectSep(path);
        const p = normalizePath(path, sep);

        if (!p) return; //already at root
        
        //Unix-like
        if (sep === "/") {                        
            if (p === "/") {
                loadDirectory(null);
                return;
            }            
            const idx = p.lastIndexOf("/");
            const parent = idx <= 0 ? "/" : p.substring(0, idx);
            loadDirectory(parent);
            return;
        }

        //Windows-like
        //Drive root case
        if (/^[a-zA-Z]:\\?$/.test(p)) {
            loadDirectory(p); // already at root, stay there
            return;
        }

        //UNC case: \\server\share\dir -> parent should be \\server\share
        if (p.startsWith("\\\\")) {
            //Split ignoring empty segments from leading "\\"            
            const parts = p.split("\\").filter(x => x.length > 0); // ["server", "share", "dir"]
            if (parts.length <= 2) {
                loadDirectory("\\\\" + parts.join("\\")); // already at root, stay there
                return;
            }
            const parentParts = parts.slice(0, parts.length - 1);
            loadDirectory("\\\\" + parentParts.join("\\"));
            return;
        }
        
        // Normal Windows path: C:\dir1\dir2 -> parent should be C:\dir1
        const idx = p.lastIndexOf("\\");
        if (idx < 0) {
            loadDirectory(p);
            return;
        }
        
        const parentCandidate = p.substring(0, idx);
        //If parent is "C:" normalize to "C:\"
        const parent = /^[a-zA-Z]:$/.test(parentCandidate) ? (parentCandidate + "\\") : parentCandidate;
        loadDirectory(parent);
    }

    function joinPath(basePath, name) {
        const sep = detectSep(basePath);
        const b = normalizePath(basePath, sep);

        if (!b) return name; //no base, just return name

        //Unix-like
        if (sep === "/") {
            if (b === "/") return "/" + name; //root case
            return b.endsWith("/") ? (b + name) : (b + "/" + name);
        }

        //Windows-like
        //If base is a drive root (C:\ or C:), ensure it ends with backslash
        return b.endsWith("\\") ? (b + name) : (b + "\\" + name);
    }
    
    function renderBreadcrumbs(path) {
        const bc = document.getElementById("breadcrumbs");
        bc.innerHTML = "";

        const sep = detectSep(path);
        const p = (path || "");

        //if empty, show nothing
        if (!p) return;

        //build clickable breadcrumbs safely
        //for UNIX: "/" + segments
        //for Windows: "C:\" + segments or "\\server\share" + segments
        //for UNC: "\\server\share" + segments
        const crumbs = computeCrumbs(p, sep);

        crumbs.forEach((c, i) => {
            if (i > 0) {
                const divider = document.createElement("span");
                divider.textContent = (sep === "\\") ? " \\ " : " / ";
                bc.appendChild(divider);
            }
            const a = document.createElement("a");
            a.href = "#";
            a.textContent = c.label;
            a.addEventListener("click", (e) => {
                e.preventDefault();
                loadDirectory(c.path);
            });
            bc.appendChild(a);
        });
    }

    function computeCrumbs(path, sep) {
        const crumbs = [];

        if (sep === "/") {
            //ensure leading path slash is treated as root crumb
            const normalized = normalizePath(path, "/") || "/";
            crumbs.push({ label: "/", path: "/" });

            if (normalized === "/") return crumbs; //only root

            const parts = normalized.split("/").filter(Boolean);
            let acc = "";
            parts.forEach(part => {
                acc += "/" + part;
                crumbs.push({ label: part, path: acc });
            });
            return crumbs;        
        }

        //windows
        //UNC
        if (path.startsWith("\\\\")) {
            const normalized = normalizePath(path, "\\");
            const parts = normalized.split("\\").filter(Boolean); // ["server", "share", "dir1", "dir2"]
            if (parts.length >= 2) {
                const root = "\\\\" + parts[0] + "\\" + parts[1];
                crumbs.push({ label: root, path: root });

                let acc = root;
                parts.slice(2).forEach(part => {
                    acc = acc + "\\" + part;    
                    crumbs.push({ label: part, path: acc });
                });
            } else {
                crumbs.push({ label: normalized, path: normalized });
            }
            return crumbs;
        }

        //Drive path: C:\...
        const driveMatch = path.match(/^([a-zA-Z]:)(\\.*)?$/);
        if (driveMatch) {
            const drive = driveMatch[1]; // e.g., "C:"
            crumbs.push({ label: drive, path: drive + "\\" });

            const normalized = normalizePath(path, "\\");
            const rest = normalized.substring(drive.length).split("\\").filter(Boolean);

            let acc = drive.replace(/\\$/, "");
            rest.forEach(part => {
                acc = acc + "\\" + part;
                crumbs.push({ label: part, path: acc });
            });
            return crumbs;
        }

        crumbs.push({ label: path, path: path });
        return crumbs;
    }

    function renderDirectoryList(currentPath, directories) {
        const container = document.getElementById("dirList");
        container.innerHTML = "";

        const list = document.createElement("ul");

        const up = document.createElement("li");
        up.textContent = "⬆ ..";
        up.addEventListener("click", () => goUp(currentPath));
        list.appendChild(up);

        directories.forEach(name => {
            const li = document.createElement("li");
            li.textContent = "📂 " + name;
            li.addEventListener("click", () => loadDirectory(joinPath(currentPath, name)));
            list.appendChild(li);
        });

        container.appendChild(list);
    }

    async function loadCsvFiles(path, mySeq) {
        const url = base + "/api/files?path=" + encodeURIComponent(path);

        try {
            const r = await fetch(url);
            if (!r.ok) throw new Error("Failed to load CSV files (HTTP ${r.status});");
            const data = await r.json();

            // Ignore out-of-order responses
            if (mySeq !== requestSeq) return;

            const container = document.getElementById("dirList");
            const list = container.querySelector("ul");
            if (!list) return;  

            (data.files || []).forEach(name => {                
                const li = document.createElement("li");
                li.textContent = "📄 " + name;

                //single click to preview, double click to open in new page
                li.addEventListener("click", () => {
                    loadCsvPreview(path, name);
                });

                //optional double click to open viewer page
                li.addEventListener("dblclick", () => {
                    window.location.href = 
                        base + "/csvviewer?path=" + encodeURIComponent(path) + 
                        "&file=" + encodeURIComponent(name);
                });

                list.appendChild(li);
            });
        } catch (err) {
            //Non-fatal error: just show message in the list
            if (mySeq !== requestSeq) return; // Ignore out-of-order responses
            const preview = document.getElementById("preview");
            preview.textContent = "";
            const div = document.createElement("div");
            div.style.color = "#b00020";
            div.textContent = "Error loading CSV files: " + (err && err.message ? err.message : "Unknown error");
            preview.appendChild(div);     
        }
    }

    async function loadCsvPreview(path, file) {
        const preview = document.getElementById("preview");
        
        //show loading message while fetching
        preview.textContent = "";
        const p = document.createElement("p");
        p.textContent = "Loading...";
        preview.appendChild(p);

        const url = base + "/csvPreview?path=" + encodeURIComponent(path) + "&file=" + encodeURIComponent(file);

        try {
            const r = await fetch(url);
            if (!r.ok) throw new Error("Failed to load CSV preview (HTTP ${r.status});");

            // NOTE this assumes /csvPreview returns safe HTML..... JASON WARNING
            const html = await r.text();

            //clear and rebuild preview with new content
            preview.innerHTML = "";

            const header = document.createElement("div");
            header.style.marginBottom = "8px";

            const a = document.createElement("a");
            a.href = base + "/csvviewer?path=" + encodeURIComponent(path) + "&file=" + encodeURIComponent(file);            
            a.textContent = "Open in CSV Viewer";

            header.appendChild(a);
            preview.appendChild(header);

            const content = document.createElement("div");
            content.innerHTML = html;
            preview.appendChild(content);

        } catch (err) {
            preview.textContent = "";
            const div = document.createElement("div");
            div.style.color = "#b00020";
            div.textContent = "Error loading CSV preview: " + (err && err.message ? err.message : "Unknown error");
            preview.appendChild(div);     
        }
    }
</script>

</body>
</html>