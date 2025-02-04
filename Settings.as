// ====== Features ======

[Setting category="Features" name="Plugin Enabled"]
bool Setting_PluginEnabled = true;

[Setting category="Features" name="Show/Hide With Game UI"]
bool Setting_HideWithGame = true;

[Setting category="Features" name="Show Pulse Animation" description="high visibility indicator"]
bool Setting_ShowAnimatedPulse = true;

// ====== layout ======

[Setting category="Layout" name="Speedlight Position" description="(horizontal, vertical)"]
vec2 Setting_Position = vec2(0.587, 0.053);

[Setting category="Layout" name="Backdrop Size" description="(width, height)"] // consider renaming variable
vec2 Setting_Size = vec2(100, 40);  

[Setting category="Layout" name="Font Size"]
float Setting_FontSize = 24;

[Setting category="Layout" name="Pulse Ring Offset" description="(horizontal, vertical)"]
vec2 Setting_PulseOffset = vec2(-80, 0);  

// ====== Triggers ======

[Setting category="Triggers" name="Live Update While Grounded"]
bool Setting_LiveUpdateGround = true;

[Setting category="Triggers" name="Live Update Always"]
bool Setting_LiveUpdateAlways = false;

[Setting category="Triggers" name="Takeoff Events"]
bool Setting_TriggerOnTakeoff = true;

// ====== Style ======

// [Setting category="Style" name="Display Event Type Icon"]
// bool Setting_DisplayEventTypeIcon = true;

[Setting category="Style" name="Backdrop Color" color]
vec4 Setting_BackdropColor = vec4(0.2, 0.2, 0.2, 0.8);

[Setting category="Style" name="Text Shadow Color" color]
vec4 Setting_ShadowColor = vec4(0, 0, 0, 1);

[Setting category="Style" name="Default Font Color" color]
vec4 Setting_DefaultFontColor = vec4(1, 1, 1, 1.0);

[Setting category="Style" name="Flying Font Color" color]
vec4 Setting_FlyingFontColor = vec4(0.1, 1, 0.9, 1.0);
