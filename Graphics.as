// types gear indications
enum GearIndicator
{
    Disengaged,   // gear is disengaged
	Engaged,      // gear is engaged
}

nvg::Font m_font;

void Render() {
    if (!Setting_PluginEnabled || (Setting_HideWithGame && !UI::IsGameUIVisible())) return; // escape if the plugin is disabled
    
    auto visState = VehicleState::ViewingPlayerState();
    if (visState is null) return; // escape if there is no active player
    if (isPlayingCutscene()) return; // hide overlay during intro cutscene

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = Setting_Position * (screenSize - Setting_Size);

    // DEV: show configured overlay position
    // nvg::BeginPath();
    // nvg::Circle(relativePos, 4);
    // nvg::FillColor(vec4(1,0,0,1));
    // nvg::Fill();

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

    // text shadow
     nvg::FillColor(Setting_ShadowColor);
    RenderSpeed(relativePos + vec2(Setting_FontSize/8, Setting_FontSize/8));
    // display text
    if(g_PrevAirborne){
        nvg::FillColor(Setting_FlyingFontColor);
    }else{
        nvg::FillColor(Setting_DefaultFontColor);
    }
    RenderSpeed(relativePos);
    RenderPulseRing(vec2(relativePos.x-(Setting_Size.x/2)-(Setting_Size.y/2),relativePos.y));
}

// not sure if this needs to be a seperate function
void RenderSpeed(const vec2 position) {
    nvg::TextAlign(nvg::Align::Middle | nvg::Align::Center);

    nvg::BeginPath();
	nvg::TextBox(position.x-Setting_Size.x/2, position.y, Setting_Size.x , padZeros(g_recentTakeOffSpeed)); // Setting_Size.x
}

// function to display speed value as full 3 digits even when below 100 speed
string padZeros(const uint value) {
    return tostring(value + 1000).SubStr(1);
}

const int PULSE_LENGTH = 300;

void RenderPulseRing(const vec2 position) {
    float pulseProgress = Math::Min(Time::get_Now() - g_recentTakeoffTime, PULSE_LENGTH);
    if(pulseProgress == PULSE_LENGTH) return;
    nvg::BeginPath();
    // nvg::Circle(position, Math::Lerp(0, Setting_Size.y/2, pulseProgress/PULSE_LENGTH));
    nvg::Circle(position, Math::Lerp(0, Setting_Size.y/2, Math::Sin((pulseProgress/PULSE_LENGTH) * Math::PI)));
    // nvg::FillColor(vec4(1,0,0,1));
    // nvg::Fill();
    nvg::StrokeColor(Setting_FlyingFontColor);
    nvg::StrokeWidth(5);
    nvg::Stroke();
}
