import json
import sys
from pathlib import Path
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup


CONFIG_PATH = Path(__file__).with_name("config.json")


def text_of(element):
    # Remove extra spaces and line breaks from the text.
    return " ".join(element.get_text(" ", strip=True).split()) if element is not None else None


def search_products(search_term, config):
    # Fetch all pages using one session to reuse connections.
    # Requests encodes the search term; timeouts and HTTP checks handle request failures.
    # Extract product details, keeping current and original prices separate.
    # Use a set for fast duplicate checks and stop after the last page.
    products = []
    seen_urls = set()
    page = 1

    with requests.Session() as session:
        while True:
            response = session.get(
                config["base_url"],
                params={"route": "product/search", "search": search_term, "page": page},
                timeout=config["timeout_seconds"],
            )
            response.raise_for_status()
            soup = BeautifulSoup(response.text, "html.parser")
            content = soup.select_one("#content")
            if content is None or content.select_one("#input-search") is None:
                raise ValueError("The website did not return a search results page.")

            for card in content.select(".product-grid-item"):
                link = card.select_one(".product-entities-title a[href]")
                if link is None:
                    raise ValueError("A product listing is missing its name or URL.")

                url = urljoin(response.url, link["href"])
                if url in seen_urls:
                    continue
                seen_urls.add(url)

                original_price = text_of(card.select_one(".price .del, .price del"))
                price = card.select_one(".price .ins")
                if price is None:
                    price = card.select_one(".price")
                    if price is not None:
                        for element in price.select(".del, del, .price-tax"):
                            element.decompose()

                products.append({
                    "name": text_of(link),
                    "url": url,
                    "price": text_of(price),
                    "original_price": original_price,
                })

            if content.select_one(".pagination li.active + li a[href]") is None:
                break
            page += 1

    return products


def main():
    # Load settings on each run and ask for the search term and output path.
    # Repeat invalid input prompts, then fetch all results before saving.
    # Write UTF-8 JSON to keep currency symbols readable and report any errors.
    try:
        config = json.loads(CONFIG_PATH.read_text(encoding="utf-8"))
        while True:
            search_term = input("Enter a product search term: ").strip()
            if search_term:
                break
            print("Error: Search term cannot be empty.", file=sys.stderr)

        while True:
            output_file = input(f"Output JSON file [{config['output_file']}] (Enter for default): ").strip()
            try:
                output_path = Path(output_file or config["output_file"]).expanduser().resolve()
                if output_path.suffix.lower() != ".json":
                    raise ValueError("Output file must have a .json extension.")
                if output_path == CONFIG_PATH.resolve():
                    raise ValueError("Output file cannot replace config.json.")
                if output_path.is_dir():
                    raise ValueError("Output path must be a file, not a directory.")
                break
            except (ValueError, OSError) as error:
                print(f"Error: {error}", file=sys.stderr)

        products = search_products(search_term, config)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        with output_path.open("w", encoding="utf-8") as output:
            json.dump(products, output, ensure_ascii=False, indent=2)
            output.write("\n")

        print(f"Saved {len(products)} products to {output_path}")
        return 0
    except (requests.RequestException, OSError, ValueError, KeyError, EOFError) as error:
        print(f"Error: {error or 'Input ended before the search was complete.'}", file=sys.stderr)
        return 1
    except KeyboardInterrupt:
        print("\nSearch cancelled.", file=sys.stderr)
        return 130


if __name__ == "__main__":
    raise SystemExit(main())
