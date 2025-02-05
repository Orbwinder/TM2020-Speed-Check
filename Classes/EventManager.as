// this file manages the event system to generate and delete events in the event queue

// predetermined array of wheel states that are considered grounded
const array<VehicleState::FallingState> GROUNDED_WHEEL_STATES = {VehicleState::FallingState::RestingGround, VehicleState::FallingState::RestingWater};

array<Event@> g_events;
uint g_recentLiveSpeed = 0;
bool g_PrevAirborne = false;
bool g_skipNextFrame = false;

uint g_prevRespawns = 0;
int g_prevRaceTime = 0;

void UpdateEvents(){
    if (!Setting_PluginEnabled) return; // escape if the plugin is disabled
    if (GetApp().CurrentPlayground is null) return; // escape if there is no loaded map

    auto nowState = VehicleState::ViewingPlayerState();
    auto RaceData = MLFeed::GetRaceData_V2();
    auto player = RaceData.GetPlayer_V2(MLFeed::LocalPlayersName);

    if (nowState is null || player is null) return; // escape if there is no player info 

    bool nowAirborne = true; // default true then check all wheels
    if(!g_skipNextFrame){
        // ignore spawning and first 15ms of race
        if (player.TheoreticalRaceTime <= 15) {
            nowAirborne = false;
        } else {
            // check if any wheels are on the ground
            for(int i=0; i<=3; i++){
                if(GROUNDED_WHEEL_STATES.Find(VehicleState::GetWheelFalling(nowState, i)) != -1) {
                    nowAirborne = false;
                    break;
                }
            }
        }

        float displaySpeed2 = nowState.WorldVel.Length() * 3.6f;

        if(Setting_TriggerOnTakeoff && nowAirborne == true && g_PrevAirborne == false) {
            // takeoff detected:
            g_events.InsertAt(0, Event(uint64(Time::get_Now()), EVENT_TYPE::Takeoff, displaySpeed2));
            g_recentLiveSpeed = int(displaySpeed2);
        }
        if(Setting_LiveUpdateGround && nowAirborne == false || Setting_LiveUpdateAlways){ 
            g_recentLiveSpeed = int(displaySpeed2);
        }

        // check for respawn/reset changes
        if ( player.NbRespawnsRequested != g_prevRespawns 
        || player.TheoreticalRaceTime < g_prevRaceTime
        ) {
            // erase all events to cancel all animations
            g_events.set_Length(0);
            g_skipNextFrame = true;
            g_recentLiveSpeed = 0;
        }
    } else {
        // after skipping the frame, reset flag
        g_skipNextFrame = false; 
    }

    // update prevAirborne
    g_PrevAirborne = nowAirborne; 
    // update others
    g_prevRespawns = uint(player.NbRespawnsRequested);
    g_prevRaceTime = int(player.TheoreticalRaceTime);

    // cleanup events array (remove expired events)
    const int eventExpiryMilis = PULSE_LENGTH;
    for(int i=g_events.Length-1; i>=0; i--){
        if (Time::Now - g_events[i].time > eventExpiryMilis) {
            // remove the event from array
            g_events.RemoveAt(i);
        }
    }
}