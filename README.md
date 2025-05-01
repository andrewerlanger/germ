# 🦠🇩🇪 Germ

**Ge**rman **R**eading **M**aterial - A simple tool to transform web articles into dual-language Kindle ebooks for language learning.

## What it does

Germ takes any web article URL and:

1. 🌐 Fetches the content
2. 🇩🇪 Translates it into German (via Gemini)
3. 📖 Creates a dual-language ebook that alternates between German paragraphs and their English counterparts, while providing a glossary of tricky German words along the way
4. 📱 Sends it directly to your Kindle

Perfect for language learners who want to practice reading in German with the support and context of the original English text.

## Setup

### Prerequisites

- Ruby 2.7+
- Gemini API key
- Gmail account (for sending to Kindle)
- Kindle email address

### Installation

```bash
# Clone the repository
git clone https://github.com/andrewerlanger/germ.git
cd germ

# Install dependencies
bundle install

# Make the executable available
chmod +x bin/germ
```

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```
GEMINI_API_KEY=your_gemini_api_key
APP_EMAIL=your_gmail_address@gmail.com
APP_EMAIL_PASSWORD=your_app_password
KINDLE_EMAIL=your_kindle_address@kindle.com
```

**Important note about APP_EMAIL**:
You need to set up an "App Password" in your Google account. This is not your regular Gmail password!

1. Go to your Google Account > Security
2. Enable 2-Step Verification if not already enabled
3. Go to "App passwords"
4. Create a new app password for "Mail" and use that as your APP_EMAIL_PASSWORD

## Usage

```bash
bin/germ "https://www.example.com/some-article"
```

Or if you add the bin directory to your PATH:

```bash
germ "https://www.example.com/some-article"
```
