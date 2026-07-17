- I have the GNU versions of tools (find, sed, grep, etc.) installed on my
  machine, not the default Mac versions. Make sure to use the GNU syntax when
  invoking these tools.
- Always run "go fmt ./..." after writing/editing Go code.
- Compile Go code with `go install ./...`, not with `go build`. The built
  executable will be available in the PATH.
- In Go code, prefer io.ReadAll + json.Unmarshal over
  json.NewDecoder().Decode(), unless working with a stream of newline-delimited
  JSON.
- Use the gopls MCP tools to explore and understand Go code, as well as to
  rename symbols (it's quite good at this).
- When researching Go libraries to understand what's possible, prefer to use the
  gopls MCP tools or `go doc` over searching around in the module cache, when
  possible.
- I often make manual changes to files after you make changes. If you encounter
  such changes, assume it was me and that it was intentional. If you think it
  was a mistake, ask me for clarification.
- If I ask you to review some code or answer a question, don't independently
  decide to make code changes without asking.
- When we are discussing things and I push back on your proposal or approach, do
  not immediately come up with a different idea and unilaterally start updating
  the code/plan. If you have a new idea for a different approach during a
  conversation, always verify it with me before proceeding with updates.
- Stop and ask me if you have any questions, or if things seem vague. Do not
  make assumptions.
- Keep PR desriptions concise and to-the-point. Do not add a bunch of extra
  sections/headers. The PR description should provide high-level context about
  what changed and why, but should not go into code-level details. The purpose
  is to convey to humans what the purpose of the PR is, and broadly how it
  achieves it.
- Do not commit or push to GitHub unless I explicitly ask you to. And if I ask
  you to once, do not take that as a standing permission.
- Do not write anything to your internal memory files without asking me first.
