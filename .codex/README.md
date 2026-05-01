# Repo-Local Codex Setup

This folder is for Codex context that should travel with this Bevy lessons repository.

## Layout

- `skills/` - repo-specific skills. Add each skill in its own folder with a `SKILL.md` entrypoint.

There is currently one repo skill: `create-lesson`, which scaffolds a numbered
lesson crate and matching PowerShell runner.

## Skill Shape

Use this structure for the next custom skill:

```text
.codex/
  skills/
    your-skill-name/
      SKILL.md
      scripts/
      examples/
      templates/
```

Only `SKILL.md` is required. Add `scripts/`, `examples/`, or `templates/` when the skill needs reusable assets.
