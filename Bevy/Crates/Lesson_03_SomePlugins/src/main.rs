use bevy::prelude::*;

#[path = "Plugins/SomePlugins.rs"]
mod some_plugins;

use some_plugins::SomePlugins;

// Single-file lesson exception: this tiny example keeps code inline and may
// break project folder/file conventions for readability.

// Builds the Lesson 03 app with a small explicit plugin group.
fn main() {
    let mut app = App::new();
    app.add_plugins(SomePlugins);
    app.add_systems(Startup, lesson_03_startup_system);
    app.run();
}

// Spawns the Lesson 03 camera and greeting text.
fn lesson_03_startup_system(mut commands: Commands) {
    commands.spawn(Camera2d);
    commands.spawn((
        Text::new("Hello, world!"),
        Node {
            position_type: PositionType::Absolute,
            top: px(12),
            left: px(12),
            ..default()
        },
    ));
    println!("Hello, world!");
}
