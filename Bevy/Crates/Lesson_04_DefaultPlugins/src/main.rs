use bevy::prelude::*;

// Single-file lesson exception: this tiny example keeps code inline and may
// break project folder/file conventions for readability.

// Builds the Lesson 04 app with Bevy default plugins.
fn main() {
    let mut app = App::new();
    app.add_plugins(DefaultPlugins);
    app.add_systems(Startup, lesson_04_startup_system);
    app.run();
}

// Spawns the Lesson 04 camera and greeting text.
fn lesson_04_startup_system(mut commands: Commands) {
    commands.spawn(Camera2d);
    commands.spawn((
        Text::new("Hello, world!"),
        TextFont::from_font_size(48.0),
        TextColor(Color::WHITE),
        Node {
            position_type: PositionType::Absolute,
            top: px(12),
            left: px(12),
            ..default()
        },
    ));
    println!("Hello, world!");
}
