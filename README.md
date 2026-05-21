# Liberty App Monitor
Initial README — project now under Git source control.

# Liberty App Monitor

A lightweight Java web application running on **Open Liberty**, designed to display CSV data, provide a clean UI for selecting PLEX environments, and offer a flexible “Select Any CSV” viewer for ad‑hoc file inspection.

This project is built for simplicity, clarity, and fast iteration — ideal for internal tooling, dashboards, and operational visibility.

---

## 🚀 Features

### ✔ PLEX CSV Viewer  
Select a PLEX from a dropdown and instantly view its CSV data rendered as a clean HTML table.

### ✔ “Select Any CSV” Tool  
Browse any directory, list CSV files, and render them in the browser using the shared CSVReader logic.

### ✔ Seasonal UI  
Automatic logo switching for:
- 🎃 Halloween (15–31 October)
- 🎄 Christmas (entire December)

Includes optional disclaimers and festive messages.

### ✔ Clean, Minimal UI  
- Styled tables  
- Animated logo  
- Auto‑submit dropdown  
- No page reload issues (pageshow fix)

---

## 📁 Project Structure

libertyappmon/
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/mfwas/
│   │   │       ├── CSVReader.java
│   │   │       ├── CsvServlet.java
│   │   │       └── SelectCsvServlet.java
│   │   └── webapp/
│   │       ├── index.jsp
│   │       ├── css/style.css
│   │       └── WEB-INF/
│   │           └── web.xml (if used)
│
├── pom.xml
├── README.md
└── .gitignore


---

## 🛠 Requirements

- Java 11+  
- Maven 3.8+  
- Open Liberty (dev mode recommended)  
- VS Code with Liberty Tools (optional but helpful)

---

## ▶ Running the Application

Start Liberty in dev mode:

```bash
mvn liberty:dev

http://localhost:9081/libertyappmon/

GET /selectCsv

Flow:
Enter directory
Choose a CSV file
View rendered table

🧩 Key Components
CSVReader.java
Reads CSV files
Converts rows into HTML tables
Shared by both servlets

CsvServlet.java
Handles PLEX‑based CSV selection
Uses request attributes to populate dropdown

SelectCsvServlet.java
Directory input
File listing
CSV rendering
Reuses CSVReader for consistency

index.jsp
Seasonal logo logic
Halloween disclaimer
Christmas greeting
PLEX dropdown
Button linking to Select Any CSV tool

🎨 UI Enhancements
Animated logo container
Styled buttons (csv-select-btn)
Hover effects
Clean table formatting
Seasonal messages

---

