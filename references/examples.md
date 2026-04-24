# lookhere Examples

Copy-paste payloads for the four most useful patterns.

---

## 1. Morning briefing (items mode)

Good for: daily action review, email triage, anything with a decision per item.

```json
{
  "title": "Morning Briefing — Apr 23",
  "metrics": [
    {"label": "Unread emails", "value": 14},
    {"label": "Slack DMs", "value": 3},
    {"label": "Tasks due today", "value": 5}
  ],
  "items": [
    {
      "title": "Reply to Maureen about Q2 kickoff",
      "context": "She sent a message Monday asking about the kickoff date. The meeting is confirmed for May 8 at 2pm. She may not know.",
      "action": ["Reply now", "Defer to Friday", "Skip"]
    },
    {
      "title": "Review Connor's edit notes for episode 12",
      "status": "waiting on Connor",
      "action": ["Open doc", "Delegate", "Done"]
    },
    {
      "title": "Update C4C waitlist email",
      "context": "The cohort is full. There are 7 people still on the waitlist from the original signup form. They haven't heard anything since March.",
      "priority": "high",
      "action": ["Draft email", "Skip for now", "Remove waitlist"]
    }
  ]
}
```

---

## 2. Decision review (doc mode with sections)

Good for: structured decisions where you want context + a clear prompt per section.

```json
{
  "mode": "doc",
  "title": "Decision: Launch format for Cohort 4",
  "subject": "Should we change the cohort format for C4?",
  "sections": [
    {
      "heading": "Background",
      "body": "C3 is running well (35 students). Two alumni (Rob, Carly) asked about a Level 2 cohort. 4 prospective students asked if there's a shorter sprint version at a lower price."
    },
    {
      "heading": "Option A: Same format",
      "body": "8 weeks, $911. Same thing that's been working. No new build required.",
      "prompt": "What's your gut reaction? Any hesitation?"
    },
    {
      "heading": "Option B: Sprint version",
      "body": "4 weeks, $499. Covers weeks 1-4 of C3 curriculum. Targets people who want to start but are unsure of the commitment.",
      "prompt": "Would this cannibalize the main cohort or expand the market?"
    },
    {
      "heading": "Option C: Level 2 cohort",
      "body": "For C1/C2/C3 alumni only. 6 weeks, focus on building real projects. $699.",
      "prompt": "Is there enough demand to justify building new curriculum?"
    }
  ],
  "signoff": "Notes go in the section note fields. Copy back when you're ready.\n-Alex"
}
```

---

## 3. Email triage (doc mode from markdown)

Good for: reviewing a draft email before sending, editing inline, copying back.

```json
{
  "mode": "doc",
  "title": "Draft: C3 Week 3 Recap",
  "text": "# Week 3 is done. Here is what to do next.\n\n## What we covered\n\nThis week was about the agentic loop. You now understand how Claude Code plans, executes, and self-corrects.\n\nThe key insight: Claude Code is not autocomplete. It runs tasks. That changes how you prompt.\n\n## Homework before Week 4\n\nBuild one tool that makes your actual job easier. Doesn't have to be fancy. Doesn't have to be finished. Just something real.\n\n> Drop your tool in #builds before Monday.\n\n- A script that formats your meeting notes\n- An agent that drafts your weekly update\n- A page that shows your tasks in a layout that makes sense to you\n\n## One thing I noticed\n\nHalf of you are still treating Claude Code like a search engine. You ask it questions instead of giving it tasks. Flip that.\n\n---\n\nSee you Wednesday.\n-Alex"
}
```

---

## 4. Draft review with batch actions (items mode)

Good for: reviewing a list of things you wrote and deciding what to keep, cut, or revise.

```json
{
  "title": "C4C LinkedIn post queue — April",
  "items": [
    {
      "title": "Post 1: The agentic loop",
      "body": "Everyone's talking about AI agents. What they actually mean: a loop where the model plans, executes, checks the result, and repeats. That's it. Once you see it, you can build it.",
      "status": "draft",
      "action": ["Approve", "Revise", "Cut"]
    },
    {
      "title": "Post 2: The prompt isn't the hard part",
      "body": "People obsess over prompts. The hard part is context. What does Claude know about your situation? What does it not know? The prompt is just the surface. Context is the whole thing.",
      "status": "draft",
      "action": ["Approve", "Revise", "Cut"]
    },
    {
      "title": "Post 3: Why I teach cohorts and not courses",
      "body": "Courses are consumed. Cohorts are lived. In a course you watch someone else build. In a cohort you build while others are building. The accountability is the product.",
      "status": "draft",
      "action": ["Approve", "Revise", "Cut"]
    }
  ]
}
```
