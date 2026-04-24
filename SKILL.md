---
name: lookhere
description: >
  Turn structured JSON into interactive HTML pages and get a shareable URL.
  Use when asked to "make a page", "build a briefing view", "create a review page",
  "publish this as a page", "make this interactive", "turn this into a triage view",
  or "show this in a browser". Pages expire in 30 days. No auth required.
---

# lookhere

Publish structured data as a styled, interactive HTML page. You get back a URL. Students open it on their phone, laptop, wherever. No login, no deploy, no setup.

**Base URL:** `https://lookhere.alex-dobrenko.workers.dev`

---

## Two modes you need

### Mode 1: Doc mode

Use this for anything you'd want to read, edit, and copy back. Emails, session recaps, drafts, weekly briefings, feedback to review.

```json
{
  "mode": "doc",
  "title": "Week 3 Recap",
  "text": "# Subject line\n\nOpening paragraph.\n\n## What we covered\n\nFirst section body.\n\nSecond paragraph.\n\n## Homework\n\nDo this thing before next session.\n\n---\n\nReply with questions.\n-Alex"
}
```

The `text` field is markdown. The renderer parses it into sections:
- `# Heading` = subject/title line
- `## Heading` = section break with heading
- `---` = section break without heading
- `> text` = callout block
- `- item` = bullet list
- Short final section with no heading = signoff

What you get: a page with Space Grotesk font, warm cream/coral palette, each section editable inline, a toolbar with "Copy Text" and "Send to Claude" buttons, and per-section note toggles. Works on mobile.

Note: "Send to Claude" copies the edited content to the clipboard as formatted text. It is NOT a live server callback. The expected next move is pasting back into the chat.

You can also use structured sections instead of markdown (more control):

```json
{
  "mode": "doc",
  "title": "Decision Review",
  "subject": "Should we add a new cohort format?",
  "sections": [
    {
      "heading": "The question",
      "body": "We have 3 students asking about a shorter format. Here's what I know."
    },
    {
      "heading": "Options",
      "body": "Option A: 4-week sprint at $499.\n\nOption B: Keep the 8-week at $911.",
      "prompt": "Which would you choose and why?"
    }
  ],
  "signoff": "Let me know your thinking.\n-Alex"
}
```

---

### Mode 2: Shape-driven items

Use this for triage, decisions, routing tasks. JSON values become UI elements automatically.

```json
{
  "title": "Morning briefing",
  "items": [
    {
      "title": "Reply to Maureen",
      "context": "She asked about the Q2 kickoff date. Left on read for 2 days.",
      "action": ["Reply today", "Defer to Friday", "Skip"]
    },
    {
      "title": "Review Connor's edit notes",
      "status": "waiting",
      "action": ["Open", "Delegate", "Done"]
    }
  ]
}
```

Value type rules (automatic, you don't pick the UI element):

| JSON value | Renders as |
|---|---|
| Short string (under 200 chars) | Read-only label |
| Long string (200+ chars) or key named `body` | Collapsible rich text |
| Array of 1-4 strings | Button group |
| Array of 5+ strings | Dropdown |
| `""` (empty string) | Text input |
| `null` | Textarea |
| `0` | Editable number |
| Non-zero number | Display number |
| `{"value": "...", "edit": true}` | Pre-filled editable field |

---

## How to publish

```bash
bash scripts/publish.sh '{"mode":"doc","title":"My Page","text":"## Hello\n\nBody text."}'
```

Returns a URL. Copy it to clipboard, open it, share it.

Or call the API directly:

```bash
curl -s -X POST \
  -H 'Content-Type: application/json' \
  -d '{"mode":"doc","title":"My Page","text":"## Hello\n\nBody text."}' \
  https://lookhere.alex-dobrenko.workers.dev/api/publish
```

Response: `{"url":"https://...","slug":"abc123","size":12345,"expires_at":"..."}`

---

## Notes

- Pages expire after 30 days.
- No auth required. Anyone with the URL can view.
- Slugs are random. Pages are not listed anywhere.
- Max payload: 5MB.

---

## Quick patterns

**Morning briefing with action buttons:**
Build an `items` array. Each item gets a `title`, optional `context` (long string, collapses automatically), and `action` array with 3-4 button labels.

**Session recap email to review:**
Use `mode: "doc"` with the email body as `text`. The person opens the page, edits inline, hits "Copy Text," pastes into Gmail.

**Batch decisions:**
Items layout with button groups. Add `"metrics": [{"label": "Total", "value": 12}]` at the top level for a summary row.

**Draft review with per-section notes:**
Doc mode with structured `sections`. Each section gets a note-toggle button on hover.

See `references/examples.md` for copy-paste examples of all four.
