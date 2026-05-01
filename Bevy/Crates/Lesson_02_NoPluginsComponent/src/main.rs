use bevy::prelude::*;
use std::time::{Duration, Instant};

#[path = "Components/LogComponent.rs"]
mod log_component;
#[path = "Systems/LogSystem.rs"]
mod log_system;

use log_component::LogComponent;
use log_system::log_update_system;

// Builds the Lesson 02 app without plugins and runs updates until the component logs.
fn main() {
    let mut app = App::new();
    let entity = app
        .world_mut()
        .spawn(LogComponent {
            started_at: Instant::now(),
            logged: false,
        })
        .id();
    app.add_systems(Update, log_update_system);

    while app
        .world()
        .get::<LogComponent>(entity)
        .is_some_and(|component| !component.logged)
    {
        app.update();
        std::thread::sleep(Duration::from_millis(100));
    }
}
