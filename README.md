# Zig-PID

Simple [PID](https://en.wikipedia.org/wiki/PID_controller) implementation written in [Zig](https://ziglang.org/).

## Using

```zig
var pid = PID.init(1, 1, 1);
pid.setSetpoint(180);
const r = pid.calculate(90);
```
