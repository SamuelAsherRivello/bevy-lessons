use bevy::prelude::*;
use std::time::Duration;

use crate::log_component::LogComponent;

// Waits one second after the component is spawned, then logs once.
pub fn log_update_system(mut query: Query<&mut LogComponent>) {
    let Ok(mut component) = query.single_mut() else {
        return;
    };

    if !component.logged && component.started_at.elapsed() >= Duration::from_secs(1) {
        println!("Lesson 02 waited one second.");
        component.logged = true;
    }
}
