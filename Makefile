.PHONY: install-r run-r report verify env-info clean

install-r:
	Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org')"

run-r:
	Rscript notebooks/ed_length_of_stay_analysis.R

report:
	pandoc report/ed_length_of_stay_report.md -o report/ed_length_of_stay_report.pdf --pdf-engine=xelatex

verify:
	Rscript -e "parse(file='notebooks/ed_length_of_stay_analysis.R'); cat('R parse check passed\\n')"
	Rscript -e "stopifnot(file.exists('data/raw/ed_length_of_stay_100k.csv')); stopifnot(file.exists('report/ed_length_of_stay_report.md')); cat('File presence check passed\\n')"

env-info:
	Rscript scripts/session_info.R

clean:
	rm -f figures/*.png
