use bevy::prelude::*;

// Single-file lesson exception: this tiny example keeps code inline and may
// break project folder/file conventions for readability.

// Builds the Lesson 01 app without plugins and runs one update.
fn main() {
    let mut app = App::new();
    app.add_systems(Update, lesson_01_update_system);
    app.update();
}

// Prints the Lesson 01 greeting during the update schedule.
fn lesson_01_update_system() {
    println!("Hello, world!");
}
