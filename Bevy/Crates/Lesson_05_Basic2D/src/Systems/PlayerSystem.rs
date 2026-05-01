use bevy::prelude::*;

use crate::player_component::PlayerComponent;

const SPEED: f32 = 220.0;

// Spawns the Lesson 04 camera and 2D player square.
pub fn player_startup_system(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<ColorMaterial>>,
) {
    commands.spawn(Camera2d);
    commands.spawn((
        Mesh2d(meshes.add(Rectangle::from_size(Vec2::splat(120.0)))),
        MeshMaterial2d(materials.add(Color::srgb(0.2, 0.7, 1.0))),
        PlayerComponent,
    ));
}

// Moves the Lesson 04 player square from keyboard input.
pub fn player_update_system(
    keys: Res<ButtonInput<KeyCode>>,
    time: Res<Time>,
    mut player: Query<&mut Transform, With<PlayerComponent>>,
) {
    let mut direction = Vec3::ZERO;
    if keys.pressed(KeyCode::KeyA) || keys.pressed(KeyCode::ArrowLeft) {
        direction.x -= 1.0;
    }
    if keys.pressed(KeyCode::KeyD) || keys.pressed(KeyCode::ArrowRight) {
        direction.x += 1.0;
    }
    if keys.pressed(KeyCode::KeyS) || keys.pressed(KeyCode::ArrowDown) {
        direction.y -= 1.0;
    }
    if keys.pressed(KeyCode::KeyW) || keys.pressed(KeyCode::ArrowUp) {
        direction.y += 1.0;
    }

    for mut transform in &mut player {
        transform.translation += direction.normalize_or_zero() * SPEED * time.delta_secs();
    }
}
