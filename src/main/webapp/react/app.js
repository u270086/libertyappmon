function Dashboard() {
    const [files, setFiles] = React.useState([]);
    const [rows, setRows] = React.useState([]);
    const [loadingFiles, setLoadingFiles] = React.useState(false);
    const [loadingCsv, setLoadingCsv] = React.useState(false);
    const [error, setError] = React.useState(null);

    const API_BASE = "/libertyappmon/api";

    React.useEffect(() => {
        loadFiles();
    }, []);

    function loadFiles() {
        setLoadingFiles(true);
        setError(null);

        fetch(API_BASE + "/csvfiles?path=H:/Documents")
            .then(r => r.json())
            .then(data => {
                setFiles(data.files || []);
                setLoadingFiles(false);
            })
            .catch(err => {
                console.error(err);
                setError("Failed to load file list");
                setLoadingFiles(false);
            });
    }

    function loadCsv(file) {
        setLoadingCsv(true);
        setError(null);

        fetch(API_BASE + "/csvfile?path=H:/Documents&file=" + file)
            .then(r => r.json())
            .then(data => {
                setRows(data.rows || []);
                setLoadingCsv(false);
            })
            .catch(err => {
                console.error(err);
                setError("Failed to load CSV file");
                setLoadingCsv(false);
            });
    }

    // Build UI without JSX
    return React.createElement("div", null,

        // Title
        React.createElement("h2", { className: "mb-4" }, "PLEX CSV Viewer (React)"),

        // Error message
        error ? React.createElement("div", { className: "alert alert-danger" }, error) : null,

        // FILE LIST CARD
        React.createElement("div", { className: "card mb-4" },
            React.createElement("div", { className: "card-header bg-primary text-white" }, "Available CSV Files"),
            React.createElement("div", { className: "card-body" },

                loadingFiles && React.createElement("div", null, "Loading files..."),

                (!loadingFiles && files.length === 0) &&
                    React.createElement("div", null, "No files found."),

                React.createElement("ul", { className: "list-group" },
                    files.map(f =>
                        React.createElement("li", {
                            key: f,
                            className: "list-group-item list-group-item-action",
                            onClick: () => loadCsv(f),
                            style: { cursor: "pointer" }
                        }, f)
                    )
                )
            )
        ),

        // CSV CONTENT CARD
        React.createElement("div", { className: "card" },
            React.createElement("div", { className: "card-header bg-secondary text-white" }, "CSV Contents"),
            React.createElement("div", { className: "card-body" },

                loadingCsv && React.createElement("div", null, "Loading CSV..."),

                (!loadingCsv && rows.length > 0) &&
                    React.createElement("div", { className: "table-responsive" },
                        React.createElement("table", { className: "table table-striped table-bordered" },
                            React.createElement("thead", null,
                                React.createElement("tr", null,
                                    rows[0].map((h, i) =>
                                        React.createElement("th", { key: i }, h)
                                    )
                                )
                            ),
                            React.createElement("tbody", null,
                                rows.slice(1).map((r, i) =>
                                    React.createElement("tr", { key: i },
                                        r.map((c, j) =>
                                            React.createElement("td", { key: j }, c)
                                        )
                                    )
                                )
                            )
                        )
                    ),

                (!loadingCsv && rows.length === 0) &&
                    React.createElement("div", null, "Select a file to view its contents.")
            )
        )
    );
}

ReactDOM.createRoot(document.getElementById("root")).render(
    React.createElement(Dashboard)
);