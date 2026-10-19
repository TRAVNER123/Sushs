# Sushs

Claude Code skills.

## Skills

### `nano-banana`

Generate and edit images with Nano Banana (Google's Gemini image models) via
the Gemini CLI's [nanobanana extension](https://github.com/gemini-cli-extensions/nanobanana).
Located at [`.claude/skills/nano-banana/`](.claude/skills/nano-banana/SKILL.md).

**Setup**

```bash
npm install -g @google/gemini-cli
gemini extensions install https://github.com/gemini-cli-extensions/nanobanana
export NANOBANANA_API_KEY="your-api-key"   # https://aistudio.google.com/apikey
.claude/skills/nano-banana/scripts/check-setup.sh
```

**Use**

Open Claude Code in this repository and ask for an image, e.g. "make a blog
header about machine learning" or "create an app icon for a todo app".
Output lands in `./nanobanana-output/`.

To use the skill in every project, copy it to your user skills directory:

```bash
cp -r .claude/skills/nano-banana ~/.claude/skills/
```

Adapted from [kkoppenhaver/cc-nano-banana](https://github.com/kkoppenhaver/cc-nano-banana) (MIT).
