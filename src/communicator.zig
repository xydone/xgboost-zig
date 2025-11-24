//pub extern fn XGCommunicatorInit(config: [*c]const u8) c_int;

//pub extern fn XGCommunicatorFinalize() c_int;

//pub extern fn XGCommunicatorGetRank() c_int;

//pub extern fn XGCommunicatorGetWorldSize() c_int;

//pub extern fn XGCommunicatorIsDistributed() c_int;

//pub extern fn XGCommunicatorPrint(message: [*c]const u8) c_int;

//pub extern fn XGCommunicatorGetProcessorName(name_str: [*c][*c]const u8) c_int;

//pub extern fn XGCommunicatorBroadcast(send_receive_buffer: ?*anyopaque, size: usize, root: c_int) c_int;

//pub extern fn XGCommunicatorAllreduce(send_receive_buffer: ?*anyopaque, count: usize, data_type: c_int, op: c_int) c_int;

const c = @import("common.zig").c;
const checkResult = @import("common.zig").checkResult;
const boolToCInt = @import("common.zig").boolToCInt;

const std = @import("std");
