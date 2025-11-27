handle: BoosterHandle,

pub const Booster = @This();

pub const BoosterHandle = c.BoosterHandle;

pub fn init(dmats: []c.DMatrixHandle, len: u64) !Booster {
    var handle: c.BoosterHandle = undefined;
    const result = c.XGBoosterCreate(
        dmats.ptr,
        len,
        &handle,
    );

    try checkResult(result);

    return .{
        .handle = handle,
    };
}

pub fn initModelFromFile(file_name: [:0]const u8) !Booster {
    var handle: c.BoosterHandle = undefined;
    const create_result = c.XGBoosterCreate(
        null,
        0,
        &handle,
    );

    try checkResult(create_result);

    const result = c.XGBoosterLoadModel(handle, file_name.ptr);

    try checkResult(result);

    return .{ .handle = handle };
}

pub fn deinit(self: Booster) void {
    const result = c.XGBoosterFree(self.handle);
    checkResult(result) catch @panic("Freeing booster failed");
}

//TODO: name as enum
pub fn setParam(self: Booster, name: [:0]const u8, value: [:0]const u8) !void {
    const result = c.XGBoosterSetParam(self.handle, name.ptr, value.ptr);
    try checkResult(result);
}

pub fn updateOneIter(self: Booster, iter: u64, dtrain: DMatrix) !void {
    const result = c.XGBoosterUpdateOneIter(self.handle, @intCast(iter), dtrain.handle);

    try checkResult(result);
}

pub fn predict(self: Booster, dmat: DMatrix, option_mask: i64, ntree_limit: u64, training: i64) ![]const f32 {
    var out_len: u64 = undefined;
    var out: [*c]const f32 = undefined;

    const result = c.XGBoosterPredict(
        self.handle,
        dmat.handle,
        @intCast(option_mask),
        @intCast(ntree_limit),
        @intCast(training),
        &out_len,
        &out,
    );

    try checkResult(result);

    return out[0..out_len];
}

pub fn dumpModel(self: Booster, fmap: [*c]const u8, with_stats: bool) ![][*c]const u8 {
    var out_len: u64 = 0;
    var out: [*c][*c]const u8 = undefined;

    const result = c.XGBoosterDumpModel(self.handle, fmap, boolToCInt(with_stats), &out_len, &out);

    try checkResult(result);

    return out[0..out_len];
}

pub fn reset(self: Booster) !void {
    const result = c.XGBoosterReset(self.handle);

    try checkResult(result);
}

pub fn slice(self: Booster, begin_layer: c_int, end_layer: c_int, step: c_int) !Booster {
    var out: c.BoosterHandle = undefined;
    const result = c.XGBoosterSlice(self.handle, begin_layer, end_layer, step, &out);

    try checkResult(result);

    return .{ .handle = out };
}

pub fn boostedRounds(self: Booster) !c_int {
    var out: c_int = undefined;

    const result = c.XGBoosterBoostedRounds(self.handle, &out);

    try checkResult(result);

    return out;
}

pub fn getNumFeature(self: Booster) !u64 {
    var out: u64 = undefined;

    const result = c.XGBoosterGetNumFeature(self.handle, &out);

    try checkResult(result);

    return out;
}

pub fn trainOneIter(self: Booster, dtrain: DMatrix, iter: i64, grad: [:0]const u8, hess: [:0]const u8) !void {
    const result = c.XGBoosterTrainOneIter(self.handle, dtrain.handle, @intCast(iter), grad.ptr, hess.ptr);

    try checkResult(result);
}

pub fn evalOneIter(self: Booster, iter: i64, dmats: []c.DMatrixHandle, evnames: [][*c]const u8) ![*c][*c]const u8 {
    const out: [*c][*c]const u8 = undefined;

    const result = c.XGBoosterEvalOneIter(self.handle, @intCast(iter), dmats.ptr, evnames.ptr, dmats.len, out);

    try checkResult(result);

    return out;
}

//pub extern fn XGBoosterPredictFromDMatrix(handle: BoosterHandle, dmat: DMatrixHandle, config: [*c]const u8, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromDense(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromColumnar(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCSR(handle: BoosterHandle, indptr: [*c]const u8, indices: [*c]const u8, values: [*c]const u8, ncol: u64, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCudaArray(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, proxy: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCudaColumnar(handle: BoosterHandle, data: [*c]const u8, config: [*c]const u8, proxy: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterLoadModel(handle: BoosterHandle, fname: [*c]const u8) c_int;

pub fn saveModel(self: Booster, file_name: [:0]const u8) !void {
    const result = c.XGBoosterSaveModel(self.handle, file_name.ptr);

    try checkResult(result);
}
//pub extern fn XGBoosterLoadModelFromBuffer(handle: BoosterHandle, buf: ?*const anyopaque, len: u64) c_int;

//pub extern fn XGBoosterSaveModelToBuffer(handle: BoosterHandle, config: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterSerializeToBuffer(handle: BoosterHandle, out_len: [*c]u64, out_dptr: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterUnserializeFromBuffer(handle: BoosterHandle, buf: ?*const anyopaque, len: u64) c_int;

//pub extern fn XGBoosterSaveJsonConfig(handle: BoosterHandle, out_len: [*c]u64, out_str: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterLoadJsonConfig(handle: BoosterHandle, config: [*c]const u8) c_int;

//pub extern fn XGBoosterDumpModelEx(handle: BoosterHandle, fmap: [*c]const u8, with_stats: c_int, format: [*c]const u8, out_len: [*c]u64, out_dump_array: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterDumpModelWithFeatures(handle: BoosterHandle, fnum: c_int, fname: [*c][*c]const u8, ftype: [*c][*c]const u8, with_stats: c_int, out_len: [*c]u64, out_models: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterDumpModelExWithFeatures(handle: BoosterHandle, fnum: c_int, fname: [*c][*c]const u8, ftype: [*c][*c]const u8, with_stats: c_int, format: [*c]const u8, out_len: [*c]u64, out_models: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterGetAttr(handle: BoosterHandle, key: [*c]const u8, out: [*c][*c]const u8, success: [*c]c_int) c_int;

//pub extern fn XGBoosterSetAttr(handle: BoosterHandle, key: [*c]const u8, value: [*c]const u8) c_int;

//pub extern fn XGBoosterGetAttrNames(handle: BoosterHandle, out_len: [*c]u64, out: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterSetStrFeatureInfo(handle: BoosterHandle, field: [*c]const u8, features: [*c][*c]const u8, size: u64) c_int;

//pub extern fn XGBoosterGetStrFeatureInfo(handle: BoosterHandle, field: [*c]const u8, len: [*c]u64, out_features: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterFeatureScore(handle: BoosterHandle, config: [*c]const u8, out_n_features: [*c]u64, out_features: [*c][*c][*c]const u8, out_dim: [*c]u64, out_shape: [*c][*c]const u64, out_scores: [*c][*c]const f32) c_int;

const DMatrix = @import("dmatrix.zig");

const c = @import("common.zig").c;
const checkResult = @import("common.zig").checkResult;
const boolToCInt = @import("common.zig").boolToCInt;

const std = @import("std");
