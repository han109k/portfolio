#!/bin/sh
# Builds a minified copy of the site into dist/ for deploying.
# The source files stay readable; edit those, never dist/.
# Needs Node (for npx). esbuild is fetched on the fly, no package.json.
set -e
cd "$(dirname "$0")"

# Version shown in the footer, from VERSION (MAJOR.MINOR.PATCH)
VERSION=$(tr -d '[:space:]' < VERSION)
if ! echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "VERSION must look like 1.2.3, got: '$VERSION'" >&2
  exit 1
fi

# Contact details, from contact.env (git-ignored; see contact.env.example)
if [ ! -f contact.env ]; then
  echo "contact.env not found: copy contact.env.example to contact.env and fill it in" >&2
  exit 1
fi
contact() { sed -n "s/^$1=//p" contact.env | tail -1 | sed 's/^["'\'']//; s/["'\'']$//'; }
EMAIL=$(contact EMAIL)
GITHUB_URL=$(contact GITHUB_URL)
LINKEDIN_URL=$(contact LINKEDIN_URL)
CV=$(contact CV)
CV=${CV%.pdf}
for key in EMAIL GITHUB_URL LINKEDIN_URL CV; do
  eval "value=\$$key"
  if [ -z "$value" ]; then
    echo "contact.env: $key is missing or empty" >&2
    exit 1
  fi
done
if ! echo "$CV" | grep -Eq '^[A-Za-z0-9._-]+$'; then
  echo "contact.env: CV may only use letters, digits, '.', '_' and '-', got: '$CV'" >&2
  exit 1
fi
if [ ! -f "assets/$CV.pdf" ]; then
  echo "contact.env: CV=$CV but assets/$CV.pdf does not exist" >&2
  exit 1
fi
export VERSION EMAIL GITHUB_URL LINKEDIN_URL CV

rm -rf dist
mkdir -p dist

# Minify CSS and JS (strips comments and whitespace, shortens JS names)
npx --yes esbuild@0.28.2 styles.css main.js --minify --outdir=dist --log-level=warning

# Copy the page without its HTML comments, stamping the version and contact details
perl -0pe '
  sub esc { my $v = shift; $v =~ s/&/&amp;/g; $v =~ s/</&lt;/g; $v =~ s/>/&gt;/g; $v =~ s/"/&quot;/g; $v }
  s/<!--.*?-->//gs;
  s/(<span data-version>)dev(<\/span>)/${1}v$ENV{VERSION}${2}/;
  s/\[YOUR EMAIL\]/esc($ENV{EMAIL})/ge;
  s/\[GITHUB URL\]/esc($ENV{GITHUB_URL})/ge;
  s/\[LINKEDIN URL\]/esc($ENV{LINKEDIN_URL})/ge;
  s/\[CV\]/$ENV{CV}/g;
' index.html > dist/index.html
grep -q "data-version>v$VERSION<" dist/index.html || { echo "footer version placeholder not found" >&2; exit 1; }
if grep -q '\[YOUR EMAIL\]\|\[GITHUB URL\]\|\[LINKEDIN URL\]\|\[CV\]' dist/index.html; then
  echo "a contact placeholder was left in dist/index.html" >&2
  exit 1
fi

# Copy assets, but only the chosen cv (other PDFs such as drafts stay local)
mkdir -p dist/assets
find assets -maxdepth 1 -type f ! -name '*.pdf' ! -name '.DS_Store' -exec cp {} dist/assets/ \;
cp "assets/$CV.pdf" dist/assets/

echo "built dist/ (v$VERSION)"
ls -l dist
