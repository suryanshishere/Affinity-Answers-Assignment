**Python Assignment (Extracting product information from MD Computers)**


What does the code do?

1. Loads the website URL, request timeout, and default output file from config.json on each run, allowing these settings to be changed without editing the code.
2. Asks for a product search term and an output file path. Asks again if either input is invalid.
3. Uses Requests to fetch search results from MD Computers.
4. Uses Beautiful Soup to parse the HTML and extract product names, URLs, current prices, and original prices where available. Product images are excluded.
5. Repeats fetching and parsing for all search results pages and removes duplicates using product URLs.
6. Saves the information to the selected JSON file. JSON was chosen because other programs can easily load the structured data and display it in a user interface. Searches with no matches produce an empty list ([]). Request or file errors are reported when they occur.



How do you run it?

1. python -m pip install -r requirements.txt
2. python main.py
3. Enter a product search term: (your search input)
4. Output JSON file [outputs.json] (Enter for default): (optional)
