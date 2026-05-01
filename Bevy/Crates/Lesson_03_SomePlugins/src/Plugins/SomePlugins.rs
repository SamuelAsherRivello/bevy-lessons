use bevy::a11y::AccessibilityPlugin;
use bevy::app::PluginGroupBuilder;
use bevy::camera::CameraPlugin;
use bevy::core_pipeline::CorePipelinePlugin;
use bevy::diagnostic::DiagnosticsPlugin;
use bevy::diagnostic::FrameCountPlugin;
use bevy::input::InputPlugin;
use bevy::mesh::MeshPlugin;
use bevy::prelude::*;
use bevy::render::RenderPlugin;
use bevy::render::pipelined_rendering::PipelinedRenderingPlugin;
use bevy::sprite::SpritePlugin;
use bevy::sprite_render::SpriteRenderPlugin;
use bevy::text::TextPlugin;
use bevy::time::TimePlugin;
use bevy::ui::UiPlugin;
use bevy::ui_render::UiRenderPlugin;
use bevy::window::WindowPlugin;
use bevy::winit::WinitPlugin;

pub struct SomePlugins;

impl PluginGroup for SomePlugins {
    fn build(self) -> PluginGroupBuilder {
        PluginGroupBuilder::start::<Self>()
            // These are pulled from DefaultPlugin AND are required to open a window and render text.
            .add(TaskPoolPlugin::default())
            .add(FrameCountPlugin)
            .add(TimePlugin)
            .add(TransformPlugin)
            .add(DiagnosticsPlugin)
            .add(InputPlugin)
            .add(WindowPlugin::default())
            .add(AccessibilityPlugin)
            .add(AssetPlugin::default())
            .add(WinitPlugin::default())
            .add(RenderPlugin::default())
            .add(ImagePlugin::default())
            .add(MeshPlugin)
            .add(CameraPlugin)
            .add(PipelinedRenderingPlugin)
            .add(CorePipelinePlugin)
            .add(SpritePlugin)
            .add(SpriteRenderPlugin)
            .add(TextPlugin)
            .add(UiPlugin)
            .add(UiRenderPlugin)
        // These are from DefaultPlugin but NOT required.
        // .add(PanicHandlerPlugin)
        // .add(TerminalCtrlCHandlerPlugin)
        // .add(LogPlugin::default())
        // .add(ScheduleRunnerPlugin::default())
        // .add(WebAssetPlugin::default())
        // .add(ScenePlugin)
        // .add(DlssInitPlugin)
        // .add(LightPlugin)
        // .add(PostProcessPlugin)
        // .add(AntiAliasPlugin)
        // .add(PbrPlugin::default())
        // .add(GltfPlugin::default())
        // .add(AudioPlugin::default())
        // .add(GilrsPlugin)
        // .add(AnimationPlugin)
        // .add(GizmoPlugin)
        // .add(GizmoRenderPlugin)
        // .add(StatesPlugin)
        // .add(CiTestingPlugin)
        // .add(HotPatchPlugin)
        // .add(DefaultPickingPlugins)
    }
}
