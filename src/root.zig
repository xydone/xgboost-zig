/// The cImport bindings, for when raw access is needed.
pub const _raw = c;

pub const DMatrixHandle = c.DMatrixHandle;
pub const BoosterHandle = c.BoosterHandle;
pub const TrackerHandle = ?*anyopaque;
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
pub const XGDMatrixCallbackNext = fn (DataIterHandle) callconv(.c) c_int;
pub const DataIterResetCallback = fn (DataIterHandle) callconv(.c) void;
//pub extern fn XGBoostVersion(major: [*c]c_int, minor: [*c]c_int, patch: [*c]c_int) void;

//pub extern fn XGBuildInfo(out: [*c][*c]const u8) c_int;

//pub extern fn XGBGetLastError(...) [*c]const u8;

//pub extern fn XGBRegisterLogCallback(callback: ?*const fn ([*c]const u8) callconv(.c) void) c_int;

//pub extern fn XGBSetGlobalConfig(config: [*c]const u8) c_int;

//pub extern fn XGBGetGlobalConfig(out_config: [*c][*c]const u8) c_int;

//pub extern fn XGDMatrixCreateFromFile(fname: [*c]const u8, silent: c_int, out: [*c]DMatrixHandle) c_int;
pub fn createDMatrixFromFile(file_name: []const u8, silent: bool) !DMatrixHandle {
    var dmatrix_handle: DMatrixHandle = undefined;
    const result = c.XGDMatrixCreateFromFile(
        file_name,
        boolToCInt(silent),
        &dmatrix_handle,
    );

    try checkResult(result);

    return dmatrix_handle;
}

// pub extern fn XGDMatrixCreateFromURI(config: [*c]const u8, out: [*c]DMatrixHandle) c_int;
pub fn createDMatrixFromURI(
    allocator: std.mem.Allocator,
    config: []const u8,
) !DMatrixHandle {
    const c_config = try allocator.dupeZ(u8, config);
    defer allocator.free(c_config);

    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromURI(
        c_config,
        &dmatrix_handle,
    );

    try checkResult(result);

    return dmatrix_handle;
}

//pub extern fn XGDMatrixCreateFromColumnar(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;
pub fn createDMatrixFromColumnar(
    allocator: std.mem.Allocator,
    data: []const u8,
    config: []const u8,
) !DMatrixHandle {
    const c_data = try allocator.dupeZ(u8, data);
    defer allocator.free(c_data);

    const c_config = try allocator.dupeZ(u8, config);
    defer allocator.free(c_config);

    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromColumnar(
        c_data,
        c_config,
        &dmatrix_handle,
    );

    try checkResult(result);

    return dmatrix_handle;
}

//pub extern fn XGDMatrixCreateFromCSR(indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, ncol: u64, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromDense(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCSC(indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, nrow: u64, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromMat(data: [*c]const f32, nrow: u64, ncol: u64, missing: f32, out: [*c]DMatrixHandle) c_int;
pub fn createDMatrixFromMat(
    data: []f32,
    rows: u64,
    cols: u64,
    missing: f32,
) !DMatrixHandle {
    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromMat(
        data.ptr,
        rows,
        cols,
        missing,
        &dmatrix_handle,
    );

    try checkResult(result);

    return dmatrix_handle;
}

//pub extern fn XGDMatrixCreateFromMat_omp(data: [*c]const f32, nrow: u64, ncol: u64, missing: f32, out: [*c]DMatrixHandle, nthread: c_int) c_int;
pub fn createDMatrixFromMat_omp(
    data: []f32,
    rows: u64,
    cols: u64,
    missing: f32,
    thread_count: u32,
) !DMatrixHandle {
    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGDMatrixCreateFromMat_omp(
        data,
        rows,
        cols,
        missing,
        &dmatrix_handle,
        thread_count,
    );

    try checkResult(result);

    return dmatrix_handle;
}

//pub extern fn XGDMatrixCreateFromCudaColumnar(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCudaArrayInterface(data: [*c]const u8, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromDataIter(data_handle: DataIterHandle, callback: ?*const XGBCallbackDataIterNext, cache_info: [*c]const u8, missing: f32, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGProxyDMatrixCreate(out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGQuantileDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, ref: DataIterHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGExtMemQuantileDMatrixCreateFromCallback(iter: DataIterHandle, proxy: DMatrixHandle, ref: DataIterHandle, reset: ?*const DataIterResetCallback, next: ?*const XGDMatrixCallbackNext, config: [*c]const u8, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGProxyDMatrixSetDataCudaArrayInterface(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataColumnar(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataCudaColumnar(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataDense(handle: DMatrixHandle, data: [*c]const u8) c_int;

//pub extern fn XGProxyDMatrixSetDataCSR(handle: DMatrixHandle, indptr: [*c]const u8, indices: [*c]const u8, data: [*c]const u8, ncol: u64) c_int;

//pub extern fn XGDMatrixSliceDMatrix(handle: DMatrixHandle, idxset: [*c]const c_int, len: u64, out: [*c]DMatrixHandle) c_int;

//pub extern fn XGDMatrixSliceDMatrixEx(handle: DMatrixHandle, idxset: [*c]const c_int, len: u64, out: [*c]DMatrixHandle, allow_groups: c_int) c_int;

//pub extern fn XGDMatrixFree(handle: DMatrixHandle) c_int;
pub fn freeMatrix(handle: DMatrixHandle) void {
    const result = c.XGDMatrixFree(handle);
    checkResult(result) catch @panic("Freeing matrix failed");
}

//pub extern fn XGDMatrixSaveBinary(handle: DMatrixHandle, fname: [*c]const u8, silent: c_int) c_int;

//pub extern fn XGDMatrixSetInfoFromInterface(handle: DMatrixHandle, field: [*c]const u8, data: [*c]const u8) c_int;

//pub extern fn XGDMatrixSetFloatInfo(handle: DMatrixHandle, field: [*c]const u8, array: [*c]const f32, len: u64) c_int;
pub fn matrixSetFloatInfo(handle: DMatrixHandle, field: []const u8, array: []f32) !void {
    const result = c.XGDMatrixSetFloatInfo(handle, field.ptr, array.ptr, array.len);

    try checkResult(result);
}

//pub extern fn XGDMatrixSetUIntInfo(handle: DMatrixHandle, field: [*c]const u8, array: [*c]const c_uint, len: u64) c_int;

//pub extern fn XGDMatrixSetStrFeatureInfo(handle: DMatrixHandle, field: [*c]const u8, features: [*c][*c]const u8, size: u64) c_int;

//pub extern fn XGDMatrixGetStrFeatureInfo(handle: DMatrixHandle, field: [*c]const u8, size: [*c]u64, out_features: [*c][*c][*c]const u8) c_int;

//pub extern fn XGDMatrixSetDenseInfo(handle: DMatrixHandle, field: [*c]const u8, data: ?*const anyopaque, size: u64, @"type": c_int) c_int;

//pub extern fn XGDMatrixGetFloatInfo(handle: DMatrixHandle, field: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const f32) c_int;

//pub extern fn XGDMatrixGetUIntInfo(handle: DMatrixHandle, field: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const c_uint) c_int;

//pub extern fn XGDMatrixNumRow(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixNumCol(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixNumNonMissing(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixDataSplitMode(handle: DMatrixHandle, out: [*c]u64) c_int;

//pub extern fn XGDMatrixGetDataAsCSR(handle: DMatrixHandle, config: [*c]const u8, out_indptr: [*c]u64, out_indices: [*c]c_uint, out_data: [*c]f32) c_int;

//pub extern fn XGDMatrixGetQuantileCut(handle: DMatrixHandle, config: [*c]const u8, out_indptr: [*c][*c]const u8, out_data: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterCreate(dmats: [*c]const DMatrixHandle, len: u64, out: [*c]BoosterHandle) c_int;
pub fn createBooster(dmats: []DMatrixHandle, len: u64) !BoosterHandle {
    var dmatrix_handle: DMatrixHandle = undefined;

    const result = c.XGBoosterCreate(
        dmats.ptr,
        len,
        &dmatrix_handle,
    );

    try checkResult(result);

    return dmatrix_handle;
}

//pub extern fn XGBoosterFree(handle: BoosterHandle) c_int;
pub fn freeBooster(handle: DMatrixHandle) void {
    const result = c.XGBoosterFree(handle);
    checkResult(result) catch @panic("Freeing booster failed");
}

//pub extern fn XGBoosterReset(handle: BoosterHandle) c_int;

//pub extern fn XGBoosterSlice(handle: BoosterHandle, begin_layer: c_int, end_layer: c_int, step: c_int, out: [*c]BoosterHandle) c_int;

//pub extern fn XGBoosterBoostedRounds(handle: BoosterHandle, out: [*c]c_int) c_int;

//pub extern fn XGBoosterSetParam(handle: BoosterHandle, name: [*c]const u8, value: [*c]const u8) c_int;
pub fn boosterSetParam(handle: BoosterHandle, name: []const u8, value: []const u8) !void {
    //TODO: name as enum
    const result = c.XGBoosterSetParam(handle, name.ptr, value.ptr);
    try checkResult(result);
}

//pub extern fn XGBoosterGetNumFeature(handle: BoosterHandle, out: [*c]u64) c_int;

//pub extern fn XGBoosterUpdateOneIter(handle: BoosterHandle, iter: c_int, dtrain: DMatrixHandle) c_int;
pub fn boosterUpdateOneIter(handle: BoosterHandle, iter: u64, dtrain: DMatrixHandle) !void {
    const result = c.XGBoosterUpdateOneIter(handle, @intCast(iter), dtrain);

    try checkResult(result);
}
//pub extern fn XGBoosterBoostOneIter(handle: BoosterHandle, dtrain: DMatrixHandle, grad: [*c]f32, hess: [*c]f32, len: u64) c_int;

//pub extern fn XGBoosterTrainOneIter(handle: BoosterHandle, dtrain: DMatrixHandle, iter: c_int, grad: [*c]const u8, hess: [*c]const u8) c_int;

//pub extern fn XGBoosterEvalOneIter(handle: BoosterHandle, iter: c_int, dmats: [*c]DMatrixHandle, evnames: [*c][*c]const u8, len: u64, out_result: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterPredict(handle: BoosterHandle, dmat: DMatrixHandle, option_mask: c_int, ntree_limit: c_uint, training: c_int, out_len: [*c]u64, out_result: [*c][*c]const f32) c_int;
pub fn boosterPredict(handle: BoosterHandle, dmat: DMatrixHandle, option_mask: i64, ntree_limit: u64, training: i64) ![]const f32 {
    var out_len: u64 = undefined;
    var out: [*c]const f32 = undefined;

    const result = c.XGBoosterPredict(
        handle,
        dmat,
        @intCast(option_mask),
        @intCast(ntree_limit),
        @intCast(training),
        &out_len,
        &out,
    );

    try checkResult(result);

    return out[0..out_len];
}

//pub extern fn XGBoosterPredictFromDMatrix(handle: BoosterHandle, dmat: DMatrixHandle, config: [*c]const u8, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromDense(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromColumnar(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCSR(handle: BoosterHandle, indptr: [*c]const u8, indices: [*c]const u8, values: [*c]const u8, ncol: u64, config: [*c]const u8, m: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCudaArray(handle: BoosterHandle, values: [*c]const u8, config: [*c]const u8, proxy: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterPredictFromCudaColumnar(handle: BoosterHandle, data: [*c]const u8, config: [*c]const u8, proxy: DMatrixHandle, out_shape: [*c][*c]const u64, out_dim: [*c]u64, out_result: [*c][*c]const f32) c_int;

//pub extern fn XGBoosterLoadModel(handle: BoosterHandle, fname: [*c]const u8) c_int;

//pub extern fn XGBoosterSaveModel(handle: BoosterHandle, fname: [*c]const u8) c_int;

//pub extern fn XGBoosterLoadModelFromBuffer(handle: BoosterHandle, buf: ?*const anyopaque, len: u64) c_int;

//pub extern fn XGBoosterSaveModelToBuffer(handle: BoosterHandle, config: [*c]const u8, out_len: [*c]u64, out_dptr: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterSerializeToBuffer(handle: BoosterHandle, out_len: [*c]u64, out_dptr: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterUnserializeFromBuffer(handle: BoosterHandle, buf: ?*const anyopaque, len: u64) c_int;

//pub extern fn XGBoosterSaveJsonConfig(handle: BoosterHandle, out_len: [*c]u64, out_str: [*c][*c]const u8) c_int;

//pub extern fn XGBoosterLoadJsonConfig(handle: BoosterHandle, config: [*c]const u8) c_int;

//pub extern fn XGBoosterDumpModel(handle: BoosterHandle, fmap: [*c]const u8, with_stats: c_int, out_len: [*c]u64, out_dump_array: [*c][*c][*c]const u8) c_int;
pub fn boosterDumpModel(handle: BoosterHandle, fmap: [*c]const u8, with_stats: bool) ![][*c]const u8 {
    var out_len: u64 = 0;
    var out: [*c][*c]const u8 = undefined;

    const result = c.XGBoosterDumpModel(handle, fmap, boolToCInt(with_stats), &out_len, &out);

    try checkResult(result);

    return out[0..out_len];
}

//pub extern fn XGBoosterDumpModelEx(handle: BoosterHandle, fmap: [*c]const u8, with_stats: c_int, format: [*c]const u8, out_len: [*c]u64, out_dump_array: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterDumpModelWithFeatures(handle: BoosterHandle, fnum: c_int, fname: [*c][*c]const u8, ftype: [*c][*c]const u8, with_stats: c_int, out_len: [*c]u64, out_models: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterDumpModelExWithFeatures(handle: BoosterHandle, fnum: c_int, fname: [*c][*c]const u8, ftype: [*c][*c]const u8, with_stats: c_int, format: [*c]const u8, out_len: [*c]u64, out_models: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterGetAttr(handle: BoosterHandle, key: [*c]const u8, out: [*c][*c]const u8, success: [*c]c_int) c_int;

//pub extern fn XGBoosterSetAttr(handle: BoosterHandle, key: [*c]const u8, value: [*c]const u8) c_int;

//pub extern fn XGBoosterGetAttrNames(handle: BoosterHandle, out_len: [*c]u64, out: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterSetStrFeatureInfo(handle: BoosterHandle, field: [*c]const u8, features: [*c][*c]const u8, size: u64) c_int;

//pub extern fn XGBoosterGetStrFeatureInfo(handle: BoosterHandle, field: [*c]const u8, len: [*c]u64, out_features: [*c][*c][*c]const u8) c_int;

//pub extern fn XGBoosterFeatureScore(handle: BoosterHandle, config: [*c]const u8, out_n_features: [*c]u64, out_features: [*c][*c][*c]const u8, out_dim: [*c]u64, out_shape: [*c][*c]const u64, out_scores: [*c][*c]const f32) c_int;

//pub extern fn XGTrackerCreate(config: [*c]const u8, handle: [*c]TrackerHandle) c_int;

//pub extern fn XGTrackerWorkerArgs(handle: TrackerHandle, args: [*c][*c]const u8) c_int;

//pub extern fn XGTrackerRun(handle: TrackerHandle, config: [*c]const u8) c_int;

//pub extern fn XGTrackerWaitFor(handle: TrackerHandle, config: [*c]const u8) c_int;

//pub extern fn XGTrackerFree(handle: TrackerHandle) c_int;

//pub extern fn XGCommunicatorInit(config: [*c]const u8) c_int;

//pub extern fn XGCommunicatorFinalize() c_int;

//pub extern fn XGCommunicatorGetRank() c_int;

//pub extern fn XGCommunicatorGetWorldSize() c_int;

//pub extern fn XGCommunicatorIsDistributed() c_int;

//pub extern fn XGCommunicatorPrint(message: [*c]const u8) c_int;

//pub extern fn XGCommunicatorGetProcessorName(name_str: [*c][*c]const u8) c_int;

//pub extern fn XGCommunicatorBroadcast(send_receive_buffer: ?*anyopaque, size: usize, root: c_int) c_int;

//pub extern fn XGCommunicatorAllreduce(send_receive_buffer: ?*anyopaque, count: usize, data_type: c_int, op: c_int) c_int;
fn checkResult(result: c_int) !void {
    if (result != 0) {
        return error.XGBoostError;
    }
}

fn boolToCInt(@"bool": bool) c_int {
    return if (@"bool") 0 else -1;
}

const c = @cImport({
    @cInclude("xgboost/c_api.h");
});

const std = @import("std");
