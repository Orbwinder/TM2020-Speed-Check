
void Main() {
    // load font
    m_font = nvg::LoadFont("DSEG7Classic-Bold.ttf");
    // loop to update events
    while (true) {
        UpdateEvents();
        yield();
    }
}

void RenderMenu() {
    if (UI::MenuItem("\\$BA1" + Icons::Kenney::Top + "\\$G Speedlight", "", Setting_PluginEnabled))
        Setting_PluginEnabled = !Setting_PluginEnabled;
}

void OnSettingsChanged()
{
    m_font = nvg::LoadFont("DSEG7Classic-Bold.ttf");
}