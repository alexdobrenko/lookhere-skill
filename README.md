# lookhere

A Claude skill that turns structured JSON into interactive HTML pages and gives you a URL.

You describe your data (morning briefing items, email drafts, decisions to review). Claude publishes it to a hosted page. You open the link, edit inline, and copy the result back.

No deploy. No login. No setup on your end. Pages expire in 30 days.

Built on Alex Dobrenko's lookhere server (Cloudflare Workers + KV). This is the student-facing version shipped to C4C Cohort 3.

---

## What it makes

**Doc mode:** Formatted document with inline-editable sections, per-section notes, and a "Copy Text / Send to Claude" toolbar. Good for email drafts, session recaps, briefings you need to review and edit.

**Items mode:** Scrollable card list where each item has action buttons and editable fields. Long context blocks (200+ chars or anything stored under a `body` key) render as full-width rich text so the whole thing is visible. Good for morning triage, batch decisions, post queues.

---

## Install

```bash
npx skills add alexdobrenko/lookhere-skill --skill lookhere -g
```

That's it. No keys, no config. The skill uses Alex's hosted server directly.

---

## Usage

Once installed, Claude will use this skill automatically when you ask it to:

- "Make a page from this"
- "Build a briefing view"
- "Publish this as a triage view"
- "Create a review page for these items"
- "Turn this into an interactive page"

No slash command. Claude picks the skill up from the description trigger, so just describe what you want in plain English.

---

## The script directly

```bash
bash scripts/publish.sh '{"mode":"doc","title":"My Draft","text":"## Section\n\nBody text."}'
```

Prints the URL. On macOS it also copies to clipboard via `pbcopy`. On Linux the URL is printed to stdout only.

---

## Examples

See `references/examples.md` for four copy-paste payloads: morning briefing, decision review, email triage, and draft review with batch actions.

---

## Files

```
SKILL.md           Claude's instructions for using the skill
README.md          This file
scripts/
  publish.sh       Shell wrapper: takes JSON, posts to API, prints URL
references/
  examples.md      4 real example payloads to steal
```
