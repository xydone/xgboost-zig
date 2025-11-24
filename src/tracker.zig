handle: TrackerHandle,

pub const TrackerHandle = c.TrackerHandle;

//pub extern fn XGTrackerCreate(config: [*c]const u8, handle: [*c]TrackerHandle) c_int;

//pub extern fn XGTrackerWorkerArgs(handle: TrackerHandle, args: [*c][*c]const u8) c_int;

//pub extern fn XGTrackerRun(handle: TrackerHandle, config: [*c]const u8) c_int;

//pub extern fn XGTrackerWaitFor(handle: TrackerHandle, config: [*c]const u8) c_int;

//pub extern fn XGTrackerFree(handle: TrackerHandle) c_int;

const c = @import("common.zig").c;
const checkResult = @import("common.zig").checkResult;
const boolToCInt = @import("common.zig").boolToCInt;

const std = @import("std");
