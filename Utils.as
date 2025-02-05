
/**
 * converts speed value to full 3 digit string even when below 100 speed. 
 * value capped at 999 to prevent rollover 
 */
string PadSpeedZeros(const uint speedValue) {
    return tostring(Math::Min(speedValue + 1000, 1999)).SubStr(1);
}

/**
 * determines if the game is currently playing the intro cutscene for a map
 */
bool isPlayingCutscene() {
    auto playground = GetApp().CurrentPlayground;

    if (playground !is null && (playground.UIConfigs.Length > 0)) {
        if (playground.UIConfigs[0].UISequence == CGamePlaygroundUIConfig::EUISequence::Intro) {
            return true;
        }
    }
    return false;
}