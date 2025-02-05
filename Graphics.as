// this file handles all NanoVG rendering

// font for rendering speed (Desg7-classic-bold from https://github.com/keshikan/DSEG)
nvg::Font m_font; 

// duration of the pulse animation in miliseconds
const int PULSE_LENGTH = 300; 

void Render() {
    if (!Setting_PluginEnabled || (Setting_HideWithGame && !UI::IsGameUIVisible())) return; // escape if the plugin is disabled
    
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return; // escape if there is no active player
    if (isPlayingCutscene()) return; // hide overlay during intro cutscene

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = Setting_Position * (screenSize - Setting_Size);

    // draw backing card
    nvg::BeginPath();
    nvg::RoundedRect(
        relativePos.x-Setting_Size.x/2, 
        relativePos.y-Setting_Size.y/2, 
        Setting_Size.x,
        Setting_Size.y,
        20
    );
    nvg::FillColor(Setting_BackdropColor);
    nvg::Fill();
    nvg::ClosePath();

    // set font style
    nvg::FontFace(m_font);
    nvg::FontSize(Setting_FontSize);

    // determine value and color to display
    uint displaySpeed = g_recentLiveSpeed;
    vec4 displayColor = Setting_DefaultFontColor;
    if (g_events.Length >= 1 && g_events[0].time - Time::get_Now() > PULSE_LENGTH){
        displaySpeed = g_events[0].vehicleSpeed;
        displayColor = Setting_FlyingFontColor;
    }

    // draw text shadow, offset scales with fontsize
    nvg::FillColor(Setting_ShadowColor);
    RenderSpeed(relativePos + vec2(Setting_FontSize/8, Setting_FontSize/8), displaySpeed);
    // display text
    if(g_PrevAirborne){
        nvg::FillColor(Setting_FlyingFontColor);
    }else{
        nvg::FillColor(displayColor);
    }
    RenderSpeed(relativePos, displaySpeed);

    // pulse rings
    if(Setting_ShowAnimatedPulse){
        const vec2 ringPosition = relativePos + Setting_PulseOffset;
        // rings backdrop
        nvg::BeginPath();
        nvg::Circle(ringPosition, Setting_Size.y/2);
        nvg::FillColor(Setting_BackdropColor);
        nvg::Fill();
        // pulse rings, render newest on top
        for(int i=g_events.Length-1; i>=0; i--){
            RenderPulseRing(ringPosition, Time::get_Now()-g_events[i].time, Setting_FlyingFontColor);
        }
    }
}

void RenderSpeed(const vec2 position, const uint speed) {
    nvg::TextAlign(nvg::Align::Middle | nvg::Align::Center);
    nvg::BeginPath();
	nvg::TextBox(position.x-Setting_Size.x/2, position.y, Setting_Size.x , PadSpeedZeros(speed));
}

void RenderPulseRing(const vec2 position, const uint diffTime, const vec4 color) {
    float pulseProgress = Math::Min(diffTime, PULSE_LENGTH);
    if(pulseProgress == PULSE_LENGTH) return;
    nvg::BeginPath();
    nvg::Circle(position, Math::Lerp(0, Setting_Size.y/2.4, Math::Sin((pulseProgress/PULSE_LENGTH) * Math::PI)));
    nvg::StrokeColor(color);
    nvg::StrokeWidth(5);
    nvg::Stroke();
}
