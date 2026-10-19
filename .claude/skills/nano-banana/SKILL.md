---
name: nano-banana
description: Generate and edit images with Nano Banana (Google's Gemini image models) through the Gemini CLI's nanobanana extension. Use whenever the user asks to create, generate, make, draw, design, or edit an image or visual asset — blog featured images, YouTube thumbnails, banners, app icons, favicons, diagrams, flowcharts, seamless patterns, illustrations, photos, comic strips, or photo restoration.
allowed-tools: Bash(gemini:*), Bash(ls:*), Bash(.claude/skills/nano-banana/scripts/check-setup.sh)
---

# Nano Banana Image Generation

Generate and edit images by driving the Gemini CLI's
[nanobanana extension](https://github.com/gemini-cli-extensions/nanobanana)
in non-interactive mode. Use this skill for every image request instead of
improvising another method.

## Before First Use

Run the setup check once per session:

```bash
.claude/skills/nano-banana/scripts/check-setup.sh
```

It verifies the `gemini` CLI, the nanobanana extension, and an API key, and
prints the fix for anything missing. If something is missing, tell the user
the fix rather than trying to work around it:

- CLI: `npm install -g @google/gemini-cli`
- Extension: `gemini extensions install https://github.com/gemini-cli-extensions/nanobanana`
- API key (from https://aistudio.google.com/apikey): `export NANOBANANA_API_KEY="..."`
  (`NANOBANANA_GEMINI_API_KEY`, `NANOBANANA_GOOGLE_API_KEY`, `GEMINI_API_KEY`
  and `GOOGLE_API_KEY` are also accepted, in that order of preference)

## How to Run Commands

Always pass `--yolo` so the CLI auto-approves its own tool calls and doesn't
hang waiting for confirmation. Wrap the slash command in double quotes and the
prompt in single quotes:

```bash
gemini --yolo "/generate 'a red fox in fresh snow, golden hour, no text' --count=2"
```

Avoid `--preview` in headless or remote environments — it tries to open an
image viewer.

## Command Selection

| User request | Command |
|--------------|---------|
| "make me a blog header", "draw a cat" | `/generate` |
| "remove the background", "change the sky" | `/edit <file>` |
| "fix this old photo" | `/restore <file>` |
| "create an app icon / favicon" | `/icon` |
| "draw a flowchart / architecture diagram" | `/diagram` |
| "create a repeating texture" | `/pattern` |
| "make a comic strip / step-by-step sequence" | `/story` |
| Anything open-ended or multi-step | `/nanobanana <natural language>` |

## Command Reference

### `/generate` — text to image

```bash
gemini --yolo "/generate 'prompt' [options]"
```

- `--count=N` — number of variations (1–8, default 1)
- `--styles="a,b"` — photorealistic, watercolor, oil-painting, sketch,
  pixel-art, anime, vintage, modern, abstract, minimalist
- `--variations="a,b"` — lighting, angle, color-palette, composition, mood,
  season, time-of-day
- `--format=grid|separate` — output arrangement (default separate)
- `--seed=N` — reproducible results

### `/edit` and `/restore` — modify an existing image

```bash
gemini --yolo "/edit photo.png 'replace the background with a beach at sunset'"
gemini --yolo "/restore old_photo.jpg 'remove scratches and restore color'"
```

Input files are searched for in the current directory, `./images/`,
`./input/`, `./nanobanana-output/`, `~/Downloads/` and `~/Desktop/`.

### `/icon`

- `--sizes="16,32,64,128,256,512,1024"`
- `--type=app-icon|favicon|ui-element`
- `--style=flat|skeuomorphic|minimal|modern`
- `--format=png|jpeg`, `--background=transparent|white|black|<color>`
- `--corners=rounded|sharp`

```bash
gemini --yolo "/icon 'minimalist checklist logo for a productivity app' --sizes='64,128,256,512' --type='app-icon' --corners='rounded'"
```

### `/diagram`

- `--type=flowchart|architecture|network|database|wireframe|mindmap|sequence`
- `--style=professional|clean|hand-drawn|technical`
- `--layout=horizontal|vertical|hierarchical|circular`
- `--complexity=simple|detailed|comprehensive`
- `--colors=mono|accent|categorical`, `--annotations=minimal|detailed`

```bash
gemini --yolo "/diagram 'OAuth login flow between browser, app server and identity provider' --type='sequence' --layout='vertical'"
```

### `/pattern`

- `--size=256x256`, `--type=seamless|texture|wallpaper`
- `--style=geometric|organic|abstract|floral|tech`
- `--density=sparse|medium|dense`, `--colors=mono|duotone|colorful`
- `--repeat=tile|mirror`

### `/story`

- `--steps=N` (2–8, default 4), `--type=story|process|tutorial|timeline`
- `--style=consistent|evolving`, `--layout=separate|grid|comic`
- `--transition=smooth|dramatic|fade`, `--format=storyboard|individual`

## Sizes and Aspect Ratios

The extension has no explicit size or aspect flag for `/generate`, so describe
the shape in the prompt ("wide 16:9 banner", "square thumbnail", "tall
vertical 9:16 story"):

| Use case | Target | Prompt hint |
|----------|--------|-------------|
| YouTube thumbnail | 1280×720 | "wide 16:9 composition" |
| Blog featured / social preview | 1200×630 | "wide landscape banner" |
| Square social post | 1080×1080 | "square composition" |
| Twitter/X header | 1500×500 | "very wide panoramic banner" |
| Vertical story | 1080×1920 | "tall vertical 9:16 composition" |

## Model Selection

Set `NANOBANANA_MODEL` before running the command:

| Model | Notes |
|-------|-------|
| `gemini-3.1-flash-image-preview` | Nano Banana 2 — default |
| `gemini-3-pro-image-preview` | Nano Banana Pro — highest quality, slower, costs more |
| `gemini-2.5-flash-image` | Nano Banana v1 — cheapest |

```bash
NANOBANANA_MODEL=gemini-3-pro-image-preview gemini --yolo "/generate 'prompt'"
```

## Writing Good Prompts

1. Be specific about subject, style, mood, color palette, lighting and
   composition.
2. Name a medium: "editorial photography", "flat vector illustration",
   "3D render", "watercolor".
3. Add "no text" unless the user wants text in the image — models often
   garble lettering. If text is wanted, quote it exactly and keep it short.
4. State the shape (see Sizes above).

Examples:

```bash
# Blog header, illustration
gemini --yolo "/generate 'modern flat illustration of a developer at a laptop, purple and blue gradient background, minimalist, wide landscape banner, no text'"

# Editorial photo, three options
gemini --yolo "/generate 'editorial photo of a coffee cup beside a laptop on a wooden desk, morning sunlight, shallow depth of field, no text' --count=3"
```

## Output and Presenting Results

Images are saved to `./nanobanana-output/` (created automatically) with
names derived from the prompt; duplicates get `_1`, `_2`, … suffixes.

After a run:

1. `ls -t nanobanana-output/ | head` to find the newest files.
2. Show the user the file path(s) (and view the image yourself with the Read
   tool if you need to describe or check it).
3. Offer a next step: variations, a style change, or an edit.

## Iterating

- "Try again" / "give me options" → regenerate with `--count=3`
- "Make it more X" → adjust the prompt and regenerate
- "Change this one" → `gemini --yolo "/edit nanobanana-output/<file>.png 'adjustment'"`
- "Different style" → add `--styles="<style>"`

## Troubleshooting

| Problem | Fix |
|---------|-----|
| "No API key found" | `export NANOBANANA_API_KEY="your-key"` |
| Command not recognized | Install the extension, then rerun |
| Quota / rate limit exceeded | Wait, or switch to `gemini-2.5-flash-image` |
| Generation refused or failed | Check the prompt for policy issues; simplify it |
| "Image not found" on edit | Move the file into a searched directory or pass its path |
| Command hangs | Make sure `--yolo` is set and `--preview` is not |

## Credits

Based on [kkoppenhaver/cc-nano-banana](https://github.com/kkoppenhaver/cc-nano-banana)
(MIT, see `LICENSE`), updated for the current nanobanana extension.
