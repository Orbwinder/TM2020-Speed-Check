
void Main() {
    // load font?
    m_font = nvg::LoadFont("DSEG7Classic-Bold.ttf");
    // loop to update events
    while (true) {
        UpdateEvents();
        yield();
    }
}

void RenderMenu() {
    if (UI::MenuItem("\\$1BA" + Icons::Kenney::Cog + "\\$G Gear-Blocks", "", Setting_PluginEnabled))
        Setting_PluginEnabled = !Setting_PluginEnabled;
}

void OnSettingsChanged()
{
    m_font = nvg::LoadFont("DSEG7Classic-Bold.ttf");
}