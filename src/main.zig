const expect = @import("std").testing.expect;

pub const PID = struct {
    p: f32,
    i: f32,
    d: f32,
    setpoint: f32,
    prevErr: f32,
    totErr: f32,

    pub fn init(p: f32, i: f32, d: f32) PID {
        return PID{
            .p = p,
            .i = i,
            .d = d,
            .setpoint = 0,
            .prevErr = 0,
            .totErr = 0,
        };
    }

    pub fn setSetpoint(self: *PID, setpoint: f32) void {
        self.setpoint = setpoint;
    }

    pub fn calculate(self: *PID, measurement: f32) f32 {
        const posErr = self.setpoint - measurement;
        const vErr = (posErr - self.prevErr) / 0.02;
        self.prevErr = posErr;
        if (self.i != 0) {
            const a = self.totErr + posErr * 0.02;
            if (a < -1 / self.i) {
                self.totErr = -1 / self.i;
            } else if (a > 1 / self.i) {
                self.totErr = 1 / self.i;
            } else self.totErr = a;
        }
        return self.p * posErr + self.i * self.totErr + self.d * vErr;
    }
};

test "basic calculations" {
    var pid = PID.init(2, 13, 7);
    pid.setSetpoint(180);
    try expect(pid.calculate(90) == 31681);
}

test "fixing error" {
    var pid = PID.init(2, 13, 7);
    pid.setSetpoint(180);
    _ = pid.calculate(90);
    try expect(pid.calculate(90) == 181);
}
