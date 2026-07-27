## Environment
- I have the GNU versions of the standard CLI tools (find, sed, grep, etc.)
  installed, not the macOS versions — use GNU syntax.

## Go
- Run `go fmt ./...` after writing/editing Go code.
- Compile with `go install ./...`, not `go build`; the binary lands in my PATH.
- Prefer `io.ReadAll` + `json.Unmarshal` over `json.NewDecoder().Decode()`,
  unless reading a stream of newline-delimited JSON.
- When researching Go libraries to understand what's possible, prefer `go doc`
  over searching around in the module cache.

## Collaboration
- When I ask you to review code or answer a question, discuss first — don't
  start editing until I say so.
- If I push back on your approach, don't silently pivot to a new one. Propose
  it and wait for my go-ahead.
- Stop and ask me for clarification if you have any questions, or if things seem
  vague. Do not make assumptions.
- I edit files while you work. Unexpected changes are mine and intentional —
  keep them; don't revert or reformat them. Ask if one looks like a mistake.
- Don't write to your memory files without asking.

## Git
- Don't stage, commit, or push unless I ask — even if the change is complete,
  tests pass, and it seems like the obvious next step. Permission is
  per-request, never standing.
- I also stage/commit/push manually, so unexpected git state is mine, not a bug.

## Style
- Comments: brief, and on types/functions over inline unless the inline code
  really needs it. Don't restate what the code does or record how we arrived at
  the design — only the non-obvious "why" of what we landed on. Most code needs
  no comment.
- PR descriptions: brief. What changed and why, and broadly how, for a human
  reader. No code-level detail, no extra sections or headers.
- File layout: constants and globals at top, then the file's primary type
  (`manager.go` → `type Manager`), then the types it depends on, then
  `NewManager`, methods, and helpers last. Most conceptually important things
  first, so a reader can skim the top and dig down.
