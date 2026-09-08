# Liberty App Monitor

A lightweight Java web application running on Open Liberty, designed for operational visibility, CSV inspection, and filesystem exploration.  
Originally built for PLEX CSV viewing, the application now includes a full **Directory Explorer** capable of browsing both Windows and USS (z/OS) filesystems.

The app is intentionally simple, fast, and easy to deploy — ideal for internal tooling, dashboards, and environment monitoring.

---

## 🚀 Features

### ✔ Universal Directory Explorer (Windows & USS)
A server‑side filesystem browser implemented using Java servlets.  
Supports:

- Directory traversal  
- Subdirectory listing  
- CSV file discovery  
- JSON responses for UI rendering  
- USS paths on z/OS (e.g. `/u/jason`, `/etc`, `/var/tmp`)  
- Windows paths when running locally  

### ✔ Full CSV Viewer
Open any CSV file and view it as a formatted HTML table using shared `CSVReader` logic.

### ✔ PLEX CSV Viewer
Select a PLEX environment and instantly render its associated CSV data.

### ✔ Seasonal UI
Automatic logo switching:
- 🎃 Halloween (15–31 October)
- 🎄 Christmas (1–31 December)

Includes optional disclaimers and festive messages.

### ✔ Clean, Minimal UI
- Styled tables  
- Animated logo  
- Breadcrumb navigation  
- Directory/file panes  
- No page reload issues (pageshow fix)

---

## 📁 Project Structure

libertyappmon/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/mfwas/
│       │       ├── CSVReader.java
│       │       ├── CSVServlet.java
│       │       ├── CSVPreviewServlet.java
│       │       ├── FileListServlet.java
│       │       ├── DirectorySearchServlet.java
│       │       ├── DownloadServlet.java
│       │       ├── IndexServlet.java
│       │       └── StartupListener.java
│       │
│       └── webapp/
│           ├── index.jsp
│           ├── directory/index.jsp
│           ├── csvviewer.jsp
│           ├── css/style.css
│           └── WEB-INF/
│               └── web.xml (if used)
│
├── pom.xml
├── README.md
└── .gitignore


---

## 🛠 Requirements

- Java 11+  
- Maven 3.8+  
- Open Liberty (dev mode recommended)  
- VS Code or IntelliJ  
- z/OS Liberty (for USS browsing)

---

## ▶ Running the Application (Local Windows)

Start Liberty in dev mode:
mvn liberty:dev

Access the app:
http://localhost:9081/libertyappmon/


### Directory Explorer Flow
1. Open **Directory Explorer**
2. Navigate directories
3. Select CSV files
4. View rendered table

### PLEX Viewer Flow
1. Choose PLEX from dropdown  
2. CSV loads instantly  
3. Table rendered using `CSVReader`

---

## 🧩 Key Components

### CSVReader.java
- Reads CSV files  
- Converts rows into HTML tables  
- Shared by all CSV‑related servlets  

### CSVServlet.java
- Handles PLEX‑based CSV selection  
- Populates dropdown  
- Renders CSV output  

### DirectorySearchServlet.java
- Lists directories (Windows or USS)  
- Returns JSON for UI  

### FileListServlet.java
- Lists CSV files in a directory  
- Returns JSON  

### CSVPreviewServlet.java
- Generates HTML preview of CSV  
- Used by Directory Explorer  

### index.jsp
- Seasonal logo logic  
- PLEX dropdown  
- Link to Directory Explorer  

### directory/index.jsp
- Full filesystem browser UI  
- Breadcrumbs  
- Directory pane  
- File pane  
- CSV preview pane  

### csvviewer.jsp
- Full CSV rendering page  

---

## 🎨 UI Enhancements

- Animated logo  
- Styled buttons  
- Hover effects  
- Clean table formatting  
- Seasonal messages  
- Two‑pane directory explorer  
- Breadcrumb navigation  

---

## 🏁 Deployment to z/OS Liberty

1. Build WAR in IntelliJ:
mvn clean package

2. Deploy WAR to z/OS Liberty server  
3. Ensure servlet mappings exist in `server.xml`  
4. Browse USS paths using Directory Explorer  
5. View CSVs directly from USS filesystem  

---

## 📌 Notes

- Browsers cannot show server‑side file explorers.  
The Directory Explorer is implemented using Java servlets and JSON.  
- On Windows, it browses local NTFS paths.  
- On z/OS, it browses USS paths.  
- No client‑side file picker is used for server browsing.

---




