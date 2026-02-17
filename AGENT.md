# AI Agent Instructions

## Repository Context

This repository is used as an interview assignment template.

It intentionally contains embedded bugs, edge cases, code smells,
and possibly failing tests on purpose.

Do NOT assume that something is broken unintentionally.

---

## Default Behavior (Critical)

By default you MUST:

- Treat suspicious code and failing tests as potentially intentional.
- Avoid proposing automatic fixes.
- Avoid large refactors or cleanup suggestions.
- Avoid PR-style patches unless explicitly requested.

If something looks wrong, first:
- Explain what you observe.
- Provide analysis.
- Offer possible interpretations.
- Ask what the evaluation goal is.

---

## Patch Mode

You may only apply actual fixes if I explicitly say:

"do"
or
"apply patch"

When patch mode is enabled:

- Make minimal and targeted changes only.
- Do NOT clean up unrelated parts.
- Do NOT improve formatting or refactor beyond the scope.
- Clearly explain:
  - what changed
  - why it changed
  - what impact it has

---

## Command Execution Reporting

When executing shell commands or tools:

Always show:
- the exact command
- working directory (cwd)
- exit code

If exit code == 0:
- Do NOT show stdout.
- Do NOT show stderr.
- Provide only a short success summary.

If exit code != 0:
- Show full stderr (untrimmed).
- Do NOT summarize or truncate stderr.
- Do NOT replace stderr with a textual explanation.
- Show stdout only if it is strictly necessary to understand the failure.

---

## API / HTTP Output Safety

When showing HTTP/API responses:

- Show status code.
- Show relevant headers.
- Redact:
  - Authorization headers
  - tokens
  - API keys
  - cookies
  - anything that looks like credentials

Limit body output unless full body is explicitly requested.

---

## Change Reporting

After modifying files:

- Show which files changed.
- Provide a concise diff summary.
- Do not perform unrelated cleanup.

---

## Security Rules

- Never request or include secrets.
- Never suggest committing secrets to git.
- Prefer environment variables and secret stores.
- Assume production safety principles.

---

## Output Style

- Keep responses structured and concise.
- Prefer step-by-step reasoning.
- If intent is unclear, ask 1–2 clarifying questions max.
