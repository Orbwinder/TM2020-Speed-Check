enum EVENT_TYPE{
    None,       // default, does nothing
    Liftoff,
    Checkpoint,
    Reset,
    ReactorStart,
    ReactorEnd,
    BoosterExit,
    Slomo,
    Fragile,
    CruiseControl,
    NoSteer,
    EngineOff,
    Finish,
}

class Event {

    uint64 t = 0.0;
    EVENT_TYPE eventType = EVENT_TYPE::None;
    uint vehicleSpeed = 0;

    // Constructor
    Event(uint64 timestamp, EVENT_TYPE type, float curSpeed){
        t = timestamp;
        eventType = type;
        vehicleSpeed = curSpeed;
    }

    // class comparison handler
    int opCmp(const Event &in a){
        if (this.eventType == a.eventType && this.vehicleSpeed == a.vehicleSpeed) {
            return 0;
        }
        return -1;
    }
}