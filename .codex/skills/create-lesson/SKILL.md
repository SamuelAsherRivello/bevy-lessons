---
name: create-lesson
description: Create a new numbered Bevy lesson crate in this repository. Use when Codex is asked to add, scaffold, or create a lesson under Bevy/Crates with a Lesson_XX_TopicSlug folder, matching Cargo.toml and src/main.rs files, a matching Scripts/Common/Run_Lesson_XX_TopicSlug.ps1 runner, and workspace/docs updates.
---

# Create Lesson

## Workflow

1. If the user did not provide a lesson topic, ask: `What lesson topic should I use for the folder name?`
2. Inspect the current repo state before editing:
   - `Bevy/Crates/Lesson_*`
   - `Scripts/Common/Run_Lesson_XX_*.ps1`
   - root `Cargo.toml`
   - `README.md` and `AGENTS.md` if they exist
3. Use `scripts/create_lesson.py` when the requested lesson is a basic Bevy App lesson. It creates:
   - `Bevy/Crates/Lesson_XX_TopicSlug/Cargo.toml`
   - `Bevy/Crates/Lesson_XX_TopicSlug/src/main.rs`
   - `Scripts/Common/Run_Lesson_XX_TopicSlug.ps1`
   - a root workspace member entry
4. Review the generated files. Adjust `main.rs` to match the lesson topic instead of leaving generic placeholder behavior.
5. Update `README.md` and `AGENTS.md` so script tables and lesson lists match the actual files.
6. Run verification:
   - `cargo check --workspace`
   - `powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_XX_TopicSlug.ps1`

## Numbering and Naming

- Use the next available numeric prefix from existing `Lesson_XX_*` folders.
- Keep lesson folders under `Bevy/Crates`.
- Format folders as `Lesson_XX_TopicSlug`, for example `Lesson_04_Events`.
- Use the full lesson folder name after `Run_` for the runner script.
- The runner script stem must be the exact lesson folder name prefixed with `Run_`, for example `Lesson_04_Events` uses `Run_Lesson_04_Events.ps1`.
- Use a lower snake case package name derived from the folder, for example `lesson_04_events`.
- Keep each lesson self-contained with its own `Cargo.toml` and `src/main.rs`.

## Code Pattern

For console-oriented starter lessons, prefer a single update tick so scripts print and exit:

```rust
use bevy::prelude::*;

fn main() {
    let mut app = App::new();
    app.add_systems(Update, hello_world);
    app.update();
}

fn hello_world() {
    println!("Hello, world!");
}
```

When using `DefaultPlugins` in a console-only lesson on Windows, avoid creating a window unless the lesson topic requires it:

```rust
use bevy::prelude::*;

fn main() {
    let mut app = App::new();
    app.add_plugins(DefaultPlugins.set(WindowPlugin {
        primary_window: None,
        ..default()
    }));
    app.add_systems(Update, hello_world);
    app.finish();
    app.cleanup();
    app.update();
}

fn hello_world() {
    println!("Hello, world!");
}
```
