# Affinity Answers Assignments

Run all commands from the project folder.

## Python Assignment

Code: [main.py](main.py)

1. Reads settings from `config.json`.
2. Asks for a search term and an output path.
3. Collects product names, links, current prices, and original prices from MD Computers.
4. Searches all result pages and removes duplicates.
5. Saves the results as JSON. The default output file is `outputs.json`.

Run:

```sh
python -m pip install -r requirements.txt
python main.py
```

Press Enter at the output prompt to use `outputs.json`.

## SQL Assignment

1. Find the queries in [sql_assignment.sql](sql_assignment.sql).
2. Read the comments for explanations.

## Shell Assignment

Code: [shell_assignment.sh](shell_assignment.sh)

1. Accepts a CSV URL as input.
2. Downloads the company data.
3. Extracts company names, headquarters locations, and founding years.
4. Sorts by founding year, oldest first. Unknown years appear last.
5. Displays tab-separated output to preserve locations containing commas.

Requires Bash, `curl`, GNU Awk (`gawk`) 5.3 or newer, and standard Unix tools.

On Windows, open Ubuntu from PowerShell:

```powershell
wsl -d Ubuntu
```

Run the script in Ubuntu or another Bash environment:

```bash
CSV_URL="https://raw.githubusercontent.com/datasets/s-and-p-500-companies/refs/heads/main/data/constituents.csv"
bash ./shell_assignment.sh "$CSV_URL"
```

To save the output:

```bash
bash ./shell_assignment.sh "$CSV_URL" > output.tsv
```
