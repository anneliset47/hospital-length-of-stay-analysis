dir.create("report", showWarnings = FALSE, recursive = TRUE)
output_path <- "report/session_info.txt"

sink(output_path)
cat("Session info generated at:", Sys.time(), "\n\n")
print(sessionInfo())
sink()

cat("Wrote", output_path, "\n")
