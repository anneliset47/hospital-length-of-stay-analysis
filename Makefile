.PHONY: install-r run-r report clean

install-r:
	Rscript -e "install.packages('IRkernel', repos='https://cloud.r-project.org')"

run-r:
	Rscript notebooks/ed_length_of_stay_analysis.R

report:
	pandoc report/ed_length_of_stay_report.md -o report/ed_length_of_stay_report.pdf --pdf-engine=xelatex

clean:
	rm -f figures/*.png
