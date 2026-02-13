# AI Agent Instructions (Repo policy)

## Context
This repository is used as an interview assignment template.
It intentionally contains embedded bugs, code smells, and failing tests on purpose.

## Default behavior (VERY IMPORTANT)
- Do NOT propose to "fix" issues by default.
- Do NOT open PR-style patch suggestions unless explicitly requested.
- Assume that suspicious code, failing tests, or security findings may be intentional parts of the assignment.

## What you SHOULD do by default
- Ask what the candidate task is (or what exactly I want to evaluate).
- Provide analysis, explanations, debugging strategies, and hints.
- Offer multiple hypotheses and ways to validate them.
- If you suggest changes, present them as options and wait for confirmation.

## When you MAY provide actual fixes/patches
Only when I explicitly say: "do" (or "apply patch").
If I do, then:
- Make minimal, targeted changes.
- Keep the intentional nature in mind: do not “clean up everything”.
- Explain exactly what you changed and why.

## Safety / secrets
- Never ask for or include secrets (tokens, passwords, private keys).
- Do not suggest committing secrets to git.
- Prefer env vars, secret stores, and CI secrets.

## Output style
- Keep responses short and step-by-step.
- If the goal is unclear, ask 1-2 clarifying questions max.
