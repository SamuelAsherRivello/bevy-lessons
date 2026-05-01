use bevy::prelude::*;
use std::time::Instant;

#[derive(Component)]
// Tracks whether Lesson 02 has logged after its one-second wait.
pub struct LogComponent {
    pub started_at: Instant,
    pub logged: bool,
}
