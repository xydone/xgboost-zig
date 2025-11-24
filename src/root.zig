/// The cImport bindings, for when raw access is needed.
pub const _raw = c;

pub const DataIterHandle = ?*anyopaque;
pub const DataHolderHandle = ?*anyopaque;
pub const XGBoostBatchCSR = extern struct {
    size: usize = @import("std").mem.zeroes(usize),
    columns: usize = @import("std").mem.zeroes(usize),
    offset: [*c]i64 = @import("std").mem.zeroes([*c]i64),
    label: [*c]f32 = @import("std").mem.zeroes([*c]f32),
    weight: [*c]f32 = @import("std").mem.zeroes([*c]f32),
    index: [*c]c_int = @import("std").mem.zeroes([*c]c_int),
    value: [*c]f32 = @import("std").mem.zeroes([*c]f32),
};
pub const XGBCallbackSetData = fn (DataHolderHandle, XGBoostBatchCSR) callconv(.c) c_int;
pub const XGBCallbackDataIterNext = fn (DataIterHandle, ?*const XGBCallbackSetData, DataHolderHandle) callconv(.c) c_int;

pub const Booster = @import("booster.zig");
pub const DMatrix = @import("dmatrix.zig");
pub const Communicator = @import("communicator.zig");
pub const Tracker = @import("tracker.zig");

//pub extern fn XGBoostVersion(major: [*c]c_int, minor: [*c]c_int, patch: [*c]c_int) void;

//pub extern fn XGBuildInfo(out: [*c][*c]const u8) c_int;

//pub extern fn XGBGetLastError(...) [*c]const u8;

//pub extern fn XGBRegisterLogCallback(callback: ?*const fn ([*c]const u8) callconv(.c) void) c_int;

//pub extern fn XGBSetGlobalConfig(config: [*c]const u8) c_int;

//pub extern fn XGBGetGlobalConfig(out_config: [*c][*c]const u8) c_int;
const c = @import("common.zig").c;
const checkResult = @import("common.zig").checkResult;
const boolToCInt = @import("common.zig").boolToCInt;

const std = @import("std");
