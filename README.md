# m40fuscation

**m40fuscation** — a compact Lua packer/loader for embedding a controlled Lua source as a single pasteable payload and executing it with a lightweight loader. The goal is practical distribution and embedding of *your own* scripts: small, self-contained, and easy to include in other projects.

> This README focuses on what m40fuscation is, how to use it, compatibility notes, and a roadmap of planned improvements. It deliberately avoids low-level step-by-step reversal instructions for packaged payloads; rely on the repository tooling to (re)generate payloads from sources you control.

---

## Current purpose

* Package a Lua script into a single data block (`obf_string` + `rev_mapping`) that can be pasted into other files.
* Provide a loader that will detect, deconstruct, and execute that embedded payload in-place when run in a trusted environment.
* Offer a convenient generation path so you can regenerate the pasteable block from a plaintext `src` you control.

## What belongs in this project

Keep the following workflow and principles in mind:

* Maintain a plaintext original for every packaged script under source control.
* Use this tool to package **only** code you own or are authorized to run.
* When distributing or embedding code, embed the generated block produced by the tooling; do not attempt to reverse packaged blocks you did not create.

---

## Quick copy-and-paste usage (concise)

1. Place the helper script in a trusted Lua environment.
2. Edit the helper and set `src = [[ ... ]]` to the plaintext of the script you control.
3. Run the helper:

   * If an embedded payload (`obf_string` + `rev_mapping`) already exists and passes validation, the loader will reconstruct and execute it.
   * If validation fails or the payload is missing, the helper will generate a fresh pasteable block and print it (and attempt to copy it to the clipboard if supported by the environment).
4. Copy the printed pasteable block into other files you own as needed.

---

## Compatibility

* Runs where standard `load` or `loadstring` is available (plain Lua, Lua-based environments that expose `load`/`loadstring`).
* Works in typical Roblox Lua / RLua contexts with caution: some runtime features (clipboard APIs, `setclipboard`, or `syn.set_clipboard`) are environment-specific. The helper attempts to detect and use common clipboard functions when available.

---

## High-level internal overview (non-reversible description)

* The packaged payload is stored as two values inside a loader file:

  * `obf_string` — a single string representing the original script as a sequence of fixed-length tokens.
  * `rev_mapping` — a lookup table mapping each token back to the original character.
* The loader performs a quick sanity check on the payload before attempting reconstruction.
* When asked to generate a payload, the tool walks the source, assigns tokens to each unique character in the order encountered, builds `obf_string` by substituting tokens, and emits a formatted pasteable block ready for embedding.
* The loader can attempt to copy the emitted block to the system clipboard using common environment APIs when available, but this is best-effort and optional.

> The README deliberately does **not** provide token-decoding tricks or reverse-engineering guidance for packaged payloads created by others.

---

## Interface & helper behavior

The helper exposes these core behaviors (callable from the single-file helper):

* `has_valid_obf()` — a quick validator to decide whether an embedded payload looks correct.
* `generate_from_src(src)` — produce `obf_string` and `rev_mapping` from a plaintext `src` you control and return a pasteable block.
* `build_pasteable_block(obf, rev)` — format the payload into a compact, copy/paste-ready Lua snippet including the file header and tables.
* `decompile_to_string()` — reconstruct the original plaintext from the embedded `obf_string` & `rev_mapping` (used only when running the loader in trusted contexts).
* `run_decompiled()` — `load`/`loadstring` + `pcall` the reconstructed chunk and print helpful status messages.

Implementation details are intentionally concise in the repository docs; refer to the source if you are contributing.

---

## Example (short)

1. Put your source into the helper as `src = [[ ... ]]`.
2. Run the helper in your environment: it will print a pasteable block such as:

```lua
-- header comments
obf_string = "~01~02~03..."
rev_mapping = {
  ["~01"] = "p",
  ["~02"] = "r",
  -- ...
}
```

3. Copy that block into other files you control; the loader will detect and execute it when present.

---

## Roadmap & planned additions

This project is small but active. The following is a non-exhaustive list of features, logic improvements, and possible changes we will add over time. These are **owner-facing** changes (tooling, packaging, UX) and not instructions for reversing payloads:

* **Modes & Configurable Packaging** — expose operation modes such as `obf_filter` (numeric flags) that control generation behavior (e.g., `1` = low, `2` = mild). These modes will change how aggressively the generator rewrites or compresses the payload format for embedding and for compatibility with different runtimes.

* **Randomized helper identifiers** — when producing helper blocks, optionally randomize internal helper function and variable names (e.g., `m40v1_xxx`) to reduce detectability in bulk but preserve correct reconstruction when the embedded `rev_mapping` is present.

* **Fake/junk insertion options** — optional insertion of plausible-but-unused helper code to make generated helpers look more "legitimate" while keeping the real payload data intact. These additions will be cosmetic only and not alter the reconstruction logic.

* **Single-line / compact output** — support a compressed single-line pasteable output for scenarios where multi-line embedding is undesirable.

* **Compression & encoding variants** — add optional compression stages (e.g., simple compression + base encoding) for smaller payload blocks when beneficial. Compression will be optional and clearly indicated in the helper header.

* **Roblox / RLua compatibility improvements** — tuning for environments where `loadstring` behaves differently or where certain APIs are not available. This includes safer loading strategies and explicit environment tables when necessary.

* **Improved error reporting** — richer diagnostics for missing tokens, invalid tables, and environment-specific failures.

* **Tooling & CLI** — small CLI script to batch-generate pasteable blocks from directories of scripts; useful for maintaining many packaged payloads.

* **Pasteable block variants** — short and long header formats, with metadata (timestamp, generator version, mode used) to aid maintainability.

* **Contributor-friendly tests** — unit tests around generation and reconstruction to ensure compatibility across Lua versions.

* **Optional clipboard behavior** — configurable attempts to set the clipboard (detect `setclipboard`, `syn.set_clipboard`, etc.) and fall back to printing when unavailable.

* **Deterministic randomness option** — allow deterministic seeding for randomized identifiers so you can reproduce outputs when you need them.

---

## Contributing

* Open issues for desired features or bugs. Provide sample inputs (source files) and expected outputs when helpful.
* Keep changes focused on helping owners package their own code and on usability (CLI, tests, docs).
* Avoid including irreversible or destructive behavior in the generator by default.

---

## Security & license

* Author: `sinsly`
* License: MIT

Do **not** use this project to conceal or distribute code you are not authorized to run. Respect platform rules, host policies, and applicable law.
