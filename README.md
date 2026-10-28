# Affinity Answers Assignments

Solutions to all assignment questions are documented below, along with links to the corresponding code files.

**Video walkthrough:** [Watch on Loom](https://www.loom.com/share/6b0ffa45d0504be59bc7d42d545dd11f)

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

### Design choices

- I used `requests` to fetch pages and Beautiful Soup to read product details from the HTML.
- Separate functions keep the code easy to follow.
- The script checks all result pages and removes duplicates using product URLs.
- Timeouts, delays, and retries handle slow requests and rate limits. These settings are in `config.json`.
- Current and original prices are saved separately, as shown on the website.

### Why JSON as Output I chose?

I chose JSON because it is easy to read and use in Python. Each product has named fields for its name, link, and prices. It also supports missing values and currency symbols.

## SQL Assignment

Queries: [sql_assignment.sql](sql_assignment.sql). Comments explain the joins, filters, aggregation, and pagination.

Use a MySQL-compatible client such as MySQL Workbench to connect to the public Rfam database. No local database import is required.

1. Create a connection using Standard TCP/IP with these settings from the [Rfam documentation](https://docs.rfam.org/en/latest/database.html):
   - Hostname: `mysql-rfam-public.ebi.ac.uk`
   - Port: `4497`
   - Username: `rfamro`
   - Password: leave blank
   - Default schema/database: `Rfam`
2. Connect and open `sql_assignment.sql` in the SQL editor.
3. Run the numbered answer queries individually, or execute the whole file. The initial queries only show sample data for exploration.
4. View the results in the client's result grid. The family query returns page 9 using `LIMIT 15 OFFSET 120`.

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
