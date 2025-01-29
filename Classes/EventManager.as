// this file manages the event system to generate and delete events in the event queue

array<Event@> g_events;
uint g_recentTakeOffSpeed = 0;
bool g_PrevAirborne = false;
bool g_skipNextFrame = false;

uint g_prevCheckpoints = 0;
uint g_prevRespawns = 0;
int g_prevRaceTime = 0;

uint64 g_recentTakeoffTime = 0; // stand-in for event time diff

void UpdateEvents(){
    if (!Setting_PluginEnabled) return; // escape if the plugin is disabled
    if (GetApp().CurrentPlayground is null) return; // escape if there is no loaded map

    auto nowState = VehicleState::ViewingPlayerState();
    auto RaceData = MLFeed::GetRaceData_V2();
    auto player = RaceData.GetPlayer_V2(MLFeed::LocalPlayersName);

    if (nowState is null || player is null) return; // escape if there is no player info 

    bool nowAirborne = true; // default true then check all wheels
    if(!g_skipNextFrame){
        // check if wheels are on the ground
        // bool nowAirborne = true; // default true then check all wheels

        // print('wheel: ' + VehicleState::GetWheelFalling(nowState, 0));
        for(int i=0; i<=3; i++){
            if(VehicleState::GetWheelFalling(nowState, i) == VehicleState::FallingState::RestingGround) {
                nowAirborne = false;
            }
        }

        // if(nowAirborne == true && g_PrevAirborne == false) { // only update on jump
        if(nowAirborne == !Setting_LiveUpdateGround && g_PrevAirborne == false) {
            // takeoff detected:
            float displaySpeed = nowState.FrontSpeed * 3.6f;
            float displaySpeed2 = nowState.WorldVel.Length() * 3.6f;
            g_recentTakeOffSpeed = displaySpeed2;
        }

        // check for respawn/reset changes
        if ( player.NbRespawnsRequested != g_prevRespawns 
        || uint(player.CpCount) < g_prevCheckpoints 
        || player.TheoreticalRaceTime < g_prevRaceTime
        ) {
            // erase all events to cancel all animations
            g_events.set_Length(0);
            g_skipNextFrame = true;
            g_recentTakeOffSpeed = 0;
        }
        
        // g_events.InsertAt(0, Event(uint64(Time::get_Now()), EVENT_TYPE::Liftoff, prevGear));
    } else {
        // after skipping the frame, reset flag
        g_skipNextFrame = false; 
    }

    if(nowAirborne && !g_PrevAirborne){
        g_recentTakeoffTime = Time::get_Now(); // game time, not race time. would race time be better?
    }
    // update prevAirborne
    g_PrevAirborne = nowAirborne; 
    // update others
    g_prevRespawns = uint(player.NbRespawnsRequested);
    g_prevCheckpoints = int(player.CpCount);
    g_prevRaceTime = int(player.TheoreticalRaceTime);

    // cleanup events array (remove expired events)
    const int eventExpiryMilis = 2000;
    for(int i=g_events.Length-1; i>=0; i--){
        if (Time::Now - g_events[i].t > eventExpiryMilis) {
            // remove the event from array
            g_events.RemoveAt(i);
        }
    }
}

// copied from NoRespawnTimer
int64 GetRaceTime(CSmScriptPlayer& scriptPlayer)
{
	if (scriptPlayer is null)
		// not playing
		return 0;
	
	auto playgroundScript = cast<CSmArenaRulesMode>(GetApp().PlaygroundScript);

	if (playgroundScript is null)
		// Online 
		return GetApp().Network.PlaygroundClientScriptAPI.GameTime - scriptPlayer.StartTime;
	else
		// Solo
		return playgroundScript.Now - scriptPlayer.StartTime;
}