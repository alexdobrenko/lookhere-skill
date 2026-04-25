---
name: lookhere
description: Build a quick review, triage, or decision page from structured data and get a shareable URL. Fires when the user wants an interactive surface to look at items, edit drafts, or click through choices. Triggers - "make a briefing view", "make a triage page", "review page for these items", "make this clickable", "let me click through these", "show me a page to review", "make a decision view", "make a page from this". Not for raw HTML files (use /publish for that). Pages expire in 30 days. No auth.
---

# lookhere

Publish structured data as a styled, interactive HTML page. You get back a URL. Students open it on their phone, laptop, wherever. No login, no deploy, no setup.

**Base URL:** `https://lookhere.alex-dobrenko.workers.dev`

---

## Picking a mode

Quick rule:

- **Reading + editing a draft** (email, recap, briefing, post copy): doc mode.
- **Triage + per-item action** (todos, decisions, routing, approvals): items mode.
- **Reference info plus actions** (notes you'll come back to AND things to act on): items mode with `body` fields on the reference items.

If the user wants to think out loud and pick a direction at the end, that's doc mode with `sections` and `prompt` fields. See "Deliberation page" in Quick patterns below.

One thing to know: in items mode, the JSON key names become the visible field labels. So `notes` shows as "Notes," `q2_status` shows as "Q2 Status." Pick keys the user will read.

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

The `prompt` field on a section renders as a styled callout block underneath the body. Use it when you want the reader to react to a specific question, not just read a paragraph.

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
| Long string (200+ chars) or key named `body` | Full-width rich text block |
| Array of 1-4 strings | Button group |
| Array of 5+ strings | Dropdown |
| `""` (empty string) | Text input |
| `null` | Textarea |
| `0` | Editable number |
| Non-zero number | Display number |
| `{"value": "...", "edit": true}` | Pre-filled editable field |

**Common trap:** plain short strings render as read-only labels. If a user wants to edit text inline (a draft, a quote, a paragraph), use the `{"value": "...", "edit": true}` form. Bare strings will silently ship as non-editable.

### Inline editable drafts (the common review pattern)

When a user says "let me edit each one inline" or "review these drafts," combine three primitives per item: editable text via `value/edit`, a button group for the action, and `null` for free notes.

```json
{
  "title": "5 LinkedIn drafts",
  "items": [
    {
      "title": "Post 1: The agentic loop",
      "draft": {"value": "Everyone's talking about AI agents...", "edit": true},
      "action": ["Approve", "Revise", "Cut"],
      "notes": null
    }
  ]
}
```

This is the shape for any "review and edit a list of things" flow.

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

### Privacy heads-up

Pages are public to anyone with the URL. The slug is random, but if it leaks (Discord paste, screen share, browser history, forwarded email), the page is open. Don't publish anything you wouldn't want a stranger to see: client emails, financial data, private DMs, anything under NDA. If in doubt, redact before you publish.

---

## Quick patterns

**Morning briefing with action buttons:**
Build an `items` array. Each item gets a `title`, optional `context` (long string renders as a rich-text block; short string renders as a read-only label), and `action` array with 3-4 button labels.

**Session recap email to review:**
Use `mode: "doc"` with the email body as `text`. The person opens the page, edits inline, hits "Copy Text," pastes into Gmail.

**Batch decisions:**
Items layout with button groups. Add `"metrics": [{"label": "Total", "value": 12}]` at the top level for a summary row.

**Draft review with per-section notes:**
Doc mode with structured `sections`. Each section gets a note-toggle button on hover.

**Deliberation page (think through a decision):**
Doc mode with `sections`. Use `body` to lay out each option's facts, then add a `prompt` field per section to ask the user a reaction question. Ends with a final section that has only a `prompt` and an empty body, where they pick a direction. This is the shape for "I need to think through these options and write notes per option."

See `references/examples.md` for copy-paste examples.
