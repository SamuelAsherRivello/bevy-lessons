use bevy::prelude::*;

#[path = "Components/PlayerComponent.rs"]
mod player_component;
#[path = "Systems/PlayerSystem.rs"]
mod player_system;

use player_system::{player_startup_system, player_update_system};

// Builds the Lesson 06 app with 3D player movement systems.
fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, player_startup_system)
        .add_systems(Update, player_update_system)
        .run();
}
