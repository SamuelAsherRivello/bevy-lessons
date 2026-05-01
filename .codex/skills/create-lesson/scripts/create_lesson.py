#!/usr/bin/env python3
"""Create a numbered Bevy lesson crate and matching run script."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


def slug_parts(topic: str) -> list[str]:
    parts = re.findall(r"[A-Za-z0-9]+", topic)
    if not parts:
        raise SystemExit("Topic must contain at least one letter or digit.")
    return parts


def title_slug(topic: str) -> str:
    return "".join(part[:1].upper() + part[1:] for part in slug_parts(topic))


def snake_slug(topic: str) -> str:
    return "_".join(part.lower() for part in slug_parts(topic))


def next_lesson_number(game_root: Path) -> int:
    numbers: list[int] = []
    for path in game_root.glob("Lesson_*"):
        if not path.is_dir():
            continue
        match = re.match(r"Lesson_(\d+)_", path.name)
        if match:
            numbers.append(int(match.group(1)))
    return max(numbers, default=0) + 1


def add_workspace_member(root: Path, member: str) -> None:
    cargo_toml = root / "Cargo.toml"
    text = cargo_toml.read_text(encoding="utf-8")
    entry = f'    "{member}",'
    if entry in text:
        return

    marker = "members = ["
    start = text.find(marker)
    if start == -1:
        raise SystemExit("Root Cargo.toml must contain a workspace members array.")
    close = text.find("]", start)
    if close == -1:
        raise SystemExit("Root Cargo.toml workspace members array is not closed.")

    replacement = text[:close] + entry + "\n" + text[close:]
    cargo_toml.write_text(replacement, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--topic", required=True, help="Lesson topic used in the folder name.")
    parser.add_argument("--repo-root", default=".", help="Repository root. Defaults to current directory.")
    parser.add_argument("--number", type=int, help="Optional explicit lesson number.")
    args = parser.parse_args()

    root = Path(args.repo_root).resolve()
    game_root = root / "Bevy" / "Crates"
    scripts_root = root / "Scripts" / "Common"

    number = args.number if args.number is not None else next_lesson_number(game_root)
    prefix = f"{number:02d}"
    folder_name = f"Lesson_{prefix}_{title_slug(args.topic)}"
    package_name = f"lesson_{prefix}_{snake_slug(args.topic)}"
    member_path = f"Bevy/Crates/{folder_name}"
    windows_member_path = member_path.replace("/", "\\")
    lesson_root = game_root / folder_name
    src_root = lesson_root / "src"
    run_script_name = f"Run_{folder_name}.ps1"
    run_script = scripts_root / run_script_name

    if lesson_root.exists():
        raise SystemExit(f"Lesson folder already exists: {lesson_root}")
    if run_script.exists():
        raise SystemExit(f"Run script already exists: {run_script}")

    src_root.mkdir(parents=True, exist_ok=False)
    scripts_root.mkdir(parents=True, exist_ok=True)

    (lesson_root / "Cargo.toml").write_text(
        f"""[package]
name = "{package_name}"
version = "0.1.0"
edition = "2024"

[dependencies]
bevy = "0.18.1"
""",
        encoding="utf-8",
    )

    (src_root / "main.rs").write_text(
        """use bevy::prelude::*;

fn main() {
    let mut app = App::new();
    app.add_systems(Update, hello_world);
    app.update();
}

fn hello_world() {
    println!("Hello, world!");
}
""",
        encoding="utf-8",
    )

    run_script.write_text(
        f"""$ErrorActionPreference = "Stop"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Resolve-Path (Join-Path $ScriptRoot "..\\..")
Set-Location $ProjectRoot

$ManifestPath = ".\\{windows_member_path}\\Cargo.toml"
if (-not (Test-Path $ManifestPath)) {{
    throw "Lesson manifest not found: $ManifestPath"
}}

cargo run --manifest-path $ManifestPath
""",
        encoding="utf-8",
    )

    add_workspace_member(root, member_path)

    print(f"Created {member_path}")
    print(f"Created Scripts/Common/{run_script_name}")
    print(f"Package: {package_name}")


if __name__ == "__main__":
    main()
