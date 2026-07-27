- I have the GNU versions of tools (find, sed, grep, etc.) installed on my
  machine, not the default Mac versions. Make sure to use the GNU syntax when
  invoking these tools.
- Always run "go fmt ./..." after writing/editing Go code.
- Compile Go code with `go install ./...`, not with `go build`. The built
  executable will be available in the PATH.
- In Go code, prefer `io.ReadAll` + `json.Unmarshal` over json.NewDecoder().Decode()`,
  unless working with a stream of newline-delimited JSON.
- Use the gopls MCP tools to explore and understand Go code/packages, as well as
  to rename symbols.
- When researching Go libraries to understand what's possible, prefer to use the
  gopls MCP tools or `go doc` over searching around in the module cache.
- I often make manual changes to files after you make changes. If you encounter
  such changes, assume it was me and that it was intentional. If you think it
  was a mistake, ask me for clarification.
- If I ask you to review some code or answer a question, don't independently
  decide to make code changes without asking first. I often want to discuss
  things first and explicitly make the final call on implementation afterwards.
- When we are discussing things and I push back on your proposal or approach, do
  not immediately come up with a different idea and unilaterally start updating
  the code/plan. If you have a new idea for a different approach during a
  conversation, always verify it with me before proceeding with updates.
- Stop and ask me for clarification if you have any questions, or if things seem
  vague. Do not make assumptions.
- Keep code comments short and to-the-point. Prefer comments on types/functions
  over in-line comments, except when the inline code really needs an
  explanation. Do not litter the code with comments describing what the code
  does (that can be gleaned from reading the code itself), and do not include
  long paragraphs describing the historical chain of reasoning that led to a
  particular design decision. The point of comments is to provide context and
  explain "why" of the code, but not everything we discuss is worth documenting
  for future readers. Only document the truly significant aspects of the design
  we finally landed on, and keep it concise. Brevity is important. Often, code
  doesn't need any comment at all.
- Keep PR descriptions concise and to-the-point. Do not add a bunch of extra
  sections/headers. The PR description should provide high-level context about
  what changed and why, but should not go into code-level details. The purpose
  is to convey to humans what the goal of the PR is, and broadly how it's
  achieved.
- Do not stage, commit, or push changes unless I explicitly ask you to. If I ask
  you to stage/commit/push once, do not take that as a standing permission going
  forwards.
- I often stage, commit, or push changes manually while you are working. Do not
  assume that changes haven't been staged/commited/pushed just because you
  didn't do it yourself. If you notice that things were staged/commited/pushed
  without your awareness, assume it was me.
- Do not write anything to your internal memory files without asking me first.
- Within a file, structure code so that constants and global variables are at
  the top of the file, followed by the primary struct/function that the file
  contains. For example, a file named `manager.go` should have the `type Manager
  struct` definition near the top, followed by any related types that it depends
  on, followed by the `NewManager` constructor, followed by methods on the
  `Manager` type, followed by helper functions. The most "important" types
  (conceptually) should be at the top, followed by the types/functions they
  depend on. This makes it easy to see the high-level role of a file, and then
  "dig into" the implementation as you scroll down.
