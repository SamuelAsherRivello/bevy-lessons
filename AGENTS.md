# AGENTS.md

## Project Overview

This repository is a small Bevy lessons workspace. Lesson crates live under
[`Bevy/Crates`](./Bevy/Crates).

The active lesson crates are:

| Package | Path | Role |
|---|---|---|
| `lesson_01_no_plugins` | `Bevy/Crates/Lesson_01_NoPlugins` | Minimal `App` with no default plugins; prints to the console. |
| `lesson_02_no_plugins_component` | `Bevy/Crates/Lesson_02_NoPluginsComponent` | Minimal `App` with no plugins; a component logs after one second. |
| `lesson_03_some_plugins` | `Bevy/Crates/Lesson_03_SomePlugins` | Minimal windowed `App` with an explicit subset of plugins; opens a window and shows text. |
| `lesson_04_default_plugins` | `Bevy/Crates/Lesson_04_DefaultPlugins` | Minimal `App` with `DefaultPlugins`; opens a window and shows text. |
| `lesson_05_basic_2d` | `Bevy/Crates/Lesson_05_Basic2D` | `DefaultPlugins` 2D movement lesson; WASD and arrow keys move a square. |
| `lesson_06_basic_3d` | `Bevy/Crates/Lesson_06_Basic3D` | `DefaultPlugins` 3D movement lesson; mirrors Lesson 05 movement with a cube. |

There is no active shared crate, hot-reload setup, asset-test setup, or runtime
plugin architecture. Do not reintroduce those unless the user explicitly asks.

## Developer Workflows

### 01. First-Time Setup

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Install_Dependencies.ps1
```

### 02. Run Lesson 01

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_01_NoPlugins.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_01_NoPlugins/Cargo.toml
```

### 03. Run Lesson 02

This script runs the `Lesson_02_NoPluginsComponent` crate.

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_02_NoPluginsComponent.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_02_NoPluginsComponent/Cargo.toml
```

### 04. Run Lesson 03

This script runs the `Lesson_03_SomePlugins` crate.

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_03_SomePlugins.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_03_SomePlugins/Cargo.toml
```

### 05. Run Lesson 04

This script runs the `Lesson_04_DefaultPlugins` crate.

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_04_DefaultPlugins.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_04_DefaultPlugins/Cargo.toml
```

### 06. Run Lesson 05

This script runs the `Lesson_05_Basic2D` crate.

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_05_Basic2D.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_05_Basic2D/Cargo.toml
```

### 07. Run Lesson 06

This script runs the `Lesson_06_Basic3D` crate.

```powershell
powershell.exe -ExecutionPolicy Bypass -File ./Scripts/Common/Run_Lesson_06_Basic3D.ps1
```

Direct command:

```powershell
cargo run --manifest-path ./Bevy/Crates/Lesson_06_Basic3D/Cargo.toml
```

### Build Only

```powershell
cargo check --workspace
```

## Conventions

- Keep each lesson self-contained with its own `Cargo.toml` and `src/main.rs`.
- Keep lesson `Cargo.toml` files basic: package metadata plus direct dependencies.
- Use TitleCase lesson folder names under `Bevy/Crates`.
- Use underscore-separated TitleCase script names under `Scripts/Common`, such as
  `Install_Dependencies.ps1` and `Run_Lesson_03_SomePlugins.ps1`.
- Lessons 01, 02, and 03 are intentionally tiny single-file examples. Their
  `main.rs` files should include a comment noting that they may keep example
  code inline and break the folder/file conventions below for readability.
- Use TitleCase file names for project-owned Bevy domain files:
  - Plugins live in a `Plugins` folder and use `FooPlugin.rs`.
  - Components live in a `Components` folder and use `FooComponent.rs`.
  - Systems live in a `Systems` folder and use `FooSystem.rs`.
  - Bundles live in a `Bundles` folder and use `FooBundle.rs`.
- Match the Rust type name to the file name stem for project-owned plugins,
  components, and bundles. Use lower_snake_case module aliases when needed to
  keep Rust module names lint-friendly.
- Name system methods with a subject and schedule suffix, such as
  `foo_startup_system` for startup systems and `foo_update_system` for update
  systems.
- Do not add plugins to `Lesson_01_NoPlugins`.
- `Lesson_02_NoPluginsComponent` should not add plugins.
- `Lesson_03_SomePlugins` should demonstrate an explicit minimal plugin group.
- `Lesson_04_DefaultPlugins` should demonstrate `DefaultPlugins` directly.
- `Lesson_05_Basic2D` and `Lesson_06_Basic3D` should stay parallel when possible.
