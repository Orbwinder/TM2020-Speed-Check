// event types for possible future functionality expansion
enum EVENT_TYPE{
    None,       // default, does nothing
    Takeoff,
    Checkpoint,
    Reset,
    ReactorStart,
    ReactorEnd,
    BoosterExit,
    Slowmo,
    Fragile,
    CruiseControl,
    NoSteer,
    EngineOff,
    Finish,
}

class Event {

    uint64 time = 0.0;
    EVENT_TYPE eventType = EVENT_TYPE::None;
    uint vehicleSpeed = 0;

    // Constructor
    Event(uint64 timestamp, EVENT_TYPE type, float curSpeed){
        time = timestamp;
        eventType = type;
        vehicleSpeed = int(curSpeed);
    }

    // class comparison handler
    int opCmp(const Event &in a){
        if (this.eventType == a.eventType && this.vehicleSpeed == a.vehicleSpeed) {
            return 0;
        }
        return -1;
    }
}