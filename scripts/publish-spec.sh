#!/bin/bash -e
# This script publishes the Product as Code specification document to the web.

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Build the specification draft document
echo "Building spec draft"
mkdir -p public/draft
npx spec-md --metadata spec/metadata.json --githubSource "https://github.com/productascode/pac-specification/blame/main/" spec/ProductAsCode.md > public/draft/index.html

# Fetch all tags (in case of shallow clone)
echo "Fetching tags..."
# Try to unshallow the repository if it's a shallow clone
if [ -f .git/shallow ]; then
  echo "Detected shallow clone, fetching full history..."
  git fetch --unshallow --tags 2>/dev/null || echo "Could not unshallow repository"
else
  git fetch --tags 2>/dev/null || echo "Could not fetch tags"
fi

# List available tags for debugging
echo "Available tags:"
git tag -l || echo "No tags found"

# Build all tagged releases
for GITTAG in $(git tag -l) ; do
  echo "Building spec release $GITTAG"
  mkdir -p "public/$GITTAG"

  # Try to get the spec file from the tagged commit
  if git show "$GITTAG:spec/ProductAsCode.md" > /tmp/ProductAsCode-$GITTAG.md 2>/dev/null; then
    echo "  Found spec/ProductAsCode.md in $GITTAG"
  elif git show "$GITTAG:versions/v0.0.1.md" > /tmp/ProductAsCode-$GITTAG.md 2>/dev/null; then
    echo "  Found versions/v0.0.1.md in $GITTAG"
  else
    echo "  Warning: Could not find spec file in $GITTAG, skipping..."
    continue
  fi

  # Build the tagged version
  npx spec-md --metadata spec/metadata.json --githubSource "https://github.com/productascode/pac-specification/blame/$GITTAG/" /tmp/ProductAsCode-$GITTAG.md > "public/$GITTAG/index.html"

  # Clean up
  rm -f /tmp/ProductAsCode-$GITTAG.md
done

# Create the index file
echo "Rebuilding: / (index)"

# Get the current date for the working draft
GITDATE=$(date +"%a, %b %-d, %Y")

HTML="<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <title>Product as Code Specification</title>
    <style>
      * {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        color: #333;
        background: #fafafa;
        line-height: 1.6;
      }
      .container {
        max-width: 900px;
        margin: 0 auto;
        padding: 3rem 2rem;
      }
      h1 {
        font-size: 2.25rem;
        font-weight: 600;
        margin: 0 0 0.5rem;
        color: #1a1a1a;
      }
      .last-updated {
        display: flex;
        align-items: center;
        gap: 0.4rem;
        color: #6b7280;
        font-size: 0.875rem;
        margin-bottom: 2rem;
      }
      .draft-section {
        background: #f9fafb;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        padding: 1.5rem;
        margin-bottom: 2rem;
      }
      .draft-link {
        display: inline-flex;
        align-items: center;
        background: #f3f4f6;
        color: #374151;
        text-decoration: none;
        padding: 0.375rem 0.875rem;
        border-radius: 6px;
        font-weight: 500;
        font-size: 0.875rem;
        transition: all 0.15s;
        border: 1px solid #e5e7eb;
      }
      .draft-link:hover {
        background: #e5e7eb;
        border-color: #d1d5db;
      }
      .draft-info {
        color: #6b7280;
        margin-top: 0.5rem;
        font-size: 0.875rem;
      }
      h2 {
        font-size: 1.5rem;
        font-weight: 600;
        margin: 2.5rem 0 1rem;
        color: #1a1a1a;
      }
      .release-list {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
      }
      .release-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: white;
        padding: 1rem 1.5rem;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
        transition: border-color 0.15s;
      }
      .release-item:hover {
        border-color: #d1d5db;
      }
      .release-left {
        display: flex;
        align-items: center;
        gap: 1.5rem;
      }
      .version-tag {
        background: #f3f4f6;
        color: #1f2937;
        padding: 0.25rem 0.75rem;
        border-radius: 4px;
        font-weight: 600;
        text-decoration: none;
        font-size: 0.875rem;
        min-width: 70px;
        text-align: center;
        transition: background-color 0.15s;
        border: 1px solid #e5e7eb;
      }
      .version-tag:hover {
        background: #e5e7eb;
      }
      .release-date {
        color: #6b7280;
        font-size: 0.875rem;
      }
      .release-notes {
        display: flex;
        align-items: center;
        gap: 0.375rem;
        color: #4b5563;
        text-decoration: none;
        font-size: 0.875rem;
        transition: color 0.15s;
      }
      .release-notes:hover {
        color: #1f2937;
      }
      .icon {
        width: 16px;
        height: 16px;
        opacity: 0.5;
      }
      @media (max-width: 768px) {
        h1 {
          font-size: 2rem;
        }
        .release-item {
          flex-direction: column;
          align-items: flex-start;
          gap: 1rem;
        }
        .release-left {
          flex-direction: column;
          align-items: flex-start;
          gap: 0.5rem;
        }
      }
    </style>
  </head>
  <body>
    <div class=\"container\">
      <h1>Product as Code</h1>
      <div class=\"last-updated\">
        <svg class=\"icon\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">
          <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z\"></path>
        </svg>
        <span>Last updated: $GITDATE</span>
      </div>

      <div class=\"draft-section\">
        <a href=\"./draft\" class=\"draft-link\" keep-hash>Working Draft</a>
        <div class=\"draft-info\">Current development version</div>
        <div class=\"draft-info\" style=\"margin-top: 1rem; text-align: right;\">$GITDATE</div>
      </div>

      <h2>Latest Releases</h2>
      <div class=\"release-list\">"

GITHUB_RELEASES="https://github.com/productascode/pac-specification/releases/tag"
# Sort tags by version number in reverse order (newest first)
for GITTAG in $(git tag -l | sort -V -r) ; do
  TAGGEDCOMMIT=$(git rev-list -1 "$GITTAG")
  GITDATE=$(git show -s --format=%cd --date=format:"%a, %b %-d, %Y" $TAGGEDCOMMIT)

  HTML="$HTML
        <div class=\"release-item\">
          <div class=\"release-left\">
            <a href=\"./$GITTAG\" class=\"version-tag\" keep-hash>$GITTAG</a>
            <span class=\"release-date\">$GITDATE</span>
          </div>
          <a href=\"$GITHUB_RELEASES/$GITTAG\" class=\"release-notes\">
            Release Notes
            <svg class=\"icon\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">
              <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14\"></path>
            </svg>
          </a>
        </div>"
done

HTML="$HTML
      </div>
    </div>
    <script>
      var links = document.getElementsByTagName('a');
      for (var i = 0; i < links.length; i++) {
        if (links[i].hasAttribute('keep-hash')) {
          links[i].href += location.hash;
          links[i].removeAttribute('keep-hash');
        }
      }
    </script>
  </body>
</html>"

echo "$HTML" > "public/index.html"

echo ""
echo "✓ Build completed successfully!"
echo ""
echo "To test locally, run:"
echo "  npm run serve"
echo "  # Then visit http://localhost:8080"