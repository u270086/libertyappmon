function toggleDownloadButton() {
  const selector = document.getElementById("plexSelector");
  const button = document.getElementById("downloadBtn");
  button.style.display = selector.value === "ALL" ? "inline-block" : "none";
}

function downloadCSV() {
  window.location.href = "DownloadServlet?plex=ALL";
}