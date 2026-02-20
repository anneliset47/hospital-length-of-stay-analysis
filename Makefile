.PHONY: install run report clean

install:
	pip install -r requirements.txt

run:
	python notebooks/ed_length_of_stay_analysis.py

report:
	pandoc report/ed_length_of_stay_report.md -o report/ed_length_of_stay_report.pdf --pdf-engine=xelatex

clean:
	rm -f figures/*_python.png
