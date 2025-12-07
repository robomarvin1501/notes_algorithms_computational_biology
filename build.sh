#!/usr/bin/env bash
set -e

# Where Cloudflare Pages expects final static files
OUTPUT_DIR="public"
mkdir -p "$OUTPUT_DIR"

# Compile each .tex file into PDF (Cloudflare’s build env allows apt installs)
for file in *.tex; do
    name="${file%.tex}"
    echo "Compiling $file -> $name.pdf"
    lualatex "$file"
    mv "$name.pdf" "$OUTPUT_DIR/"
done

# Generate index.html
INDEX="$OUTPUT_DIR/index.html"

echo "<!DOCTYPE html>" > "$INDEX"
echo "<head>
              <title>Lecture Notes</title>
              <style>
                  body {
                      font-family: Arial, sans-serif;
                      text-align: center;
                      padding: 20px;
                      background-color: #121212;
                      color: #e0e0e0;
                  }

                  h1 {
                      color: #d7d4cf;
                  }

                  ul {
                      list-style-type: none;
                      padding: 0;
                  }

                  li {
                      margin: 10px 0;
                  }

                  a {
                      text-decoration: none;
                      color: #64b5f6;
                      font-size: 18px;
                      transition: color 0.2s;
                  }

                  a:hover {
                      color: #bbdefb;
                      text-decoration: underline;
                  }
              </style>
              <!-- Cloudflare Web Analytics -->
              <script defer src='https://static.cloudflareinsights.com/beacon.min.js' data-cf-beacon='{"token": "d21d8bf953444260923f9acabf4f3535"}'></script>
              <!-- End Cloudflare Web Analytics -->
          </head>
" >> "$INDEX"
echo "<h1>Notes</h1><ul>" >> "$INDEX"
for pdf in "$OUTPUT_DIR"/*.pdf; do
    base=$(basename "$pdf")
    echo "<li><a href=\"$base\">$base</a></li>" >> "$INDEX"
done

echo "</ul></body></html>" >> "$INDEX"

